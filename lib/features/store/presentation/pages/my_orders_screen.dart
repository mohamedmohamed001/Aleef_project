import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/store_provider.dart';
import 'details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StoreProvider>();
      provider.getUpcomingOrders();
      provider.getPreviousOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Upcoming Orders"),
            Tab(text: "Previous Orders"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(
            storeProvider.upcomingOrders,
            storeProvider.isLoadingUpcoming,
            true,
          ),
          _buildOrdersList(
            storeProvider.previousOrders,
            storeProvider.isLoadingPrevious,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
    List<Map<String, dynamic>> orders,
    bool isLoading,
    bool showTracking,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(child: Text("No orders found"));
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, showTracking, index);
      },
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
    bool showTracking,
    int index,
  ) {
    final items = order['items'] as List<dynamic>? ?? [];
    final total = order['totalOrder'] ?? 0;
    final orderCode = "ORD-2026-${index + 1}";
    final dateFormatted = items.isNotEmpty
        ? DateFormat(
            "MMM d, yyyy",
          ).format(DateTime.parse(items[0]['createdAt']))
        : "Unknown date";
    final status = order['status'] ?? "Pending";

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  صف فيه الكود والتاريخ والحالة على جنب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormatted,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            "${items.length} items • \$${total.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          //  عرض المنتجات بالصور
          Column(
            children: items.map((item) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    item['image'] ?? '',
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text("x${item['quantity']} • \$${item['price']}"),
              );
            }).toList(),
          ),

          if (showTracking) ...[
            const SizedBox(height: 12),
            _buildTrackingBar(status),
          ],

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      productId: order['_id'],
                      orderData: order,
                    ),
                  ),
                );
              },
              child: const Text(
                "View Order Details",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingBar(String status) {
    final stages = ["Order", "Processing", "Shipped", "Out", "Delivered"];
    int currentStage = 0;

    if (status.toLowerCase() == "pending") currentStage = 0;
    if (status.toLowerCase() == "processing") currentStage = 1;
    if (status.toLowerCase() == "shipped") currentStage = 2;
    if (status.toLowerCase() == "out") currentStage = 3;
    if (status.toLowerCase() == "delivered") currentStage = 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isActive = index <= currentStage;

        return Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: isActive ? AppColors.primary : Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "shipped":
        return Colors.purple;
      case "out":
        return Colors.teal;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
