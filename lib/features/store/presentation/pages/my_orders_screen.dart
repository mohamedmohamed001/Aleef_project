import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() async {
    final provider = context.read<StoreProvider>();
    await Future.wait([
      provider.getUpcomingOrders(),
      provider.getPreviousOrders(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 14.h),
            _buildTabs(),
            SizedBox(height: 10.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(
                    orders: storeProvider.upcomingOrders,
                    isLoading: storeProvider.isLoadingUpcoming,
                    showTracking: true,
                  ),
                  _buildOrdersList(
                    orders: storeProvider.previousOrders,
                    isLoading: storeProvider.isLoadingPrevious,
                    showTracking: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          _circleIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'My Orders',
                  style: TextStyle(
                    color: const Color(0xFF1D1E20),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Track your store purchases',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.42),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _circleIconButton(
            icon: Icons.receipt_long_rounded,
            onTap: _refreshOrders,
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 21.sp,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF687472),
        labelStyle: TextStyle(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w700,
        ),
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Previous'),
        ],
      ),
    );
  }

  Widget _buildOrdersList({
    required List<Map<String, dynamic>> orders,
    required bool isLoading,
    required bool showTracking,
  }) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (orders.isEmpty) {
      return _emptyState(showTracking);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refreshOrders,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        itemCount: orders.length,
        separatorBuilder: (context, index) => SizedBox(height: 14.h),
        itemBuilder: (context, index) {
          return _buildOrderCard(
            order: orders[index],
            showTracking: showTracking,
            index: index,
          );
        },
      ),
    );
  }

  Widget _emptyState(bool isUpcoming) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refreshOrders,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Icon(
            isUpcoming
                ? Icons.local_shipping_outlined
                : Icons.inventory_2_outlined,
            color: AppColors.primary.withValues(alpha: 0.35),
            size: 76.sp,
          ),
          SizedBox(height: 18.h),
          Center(
            child: Text(
              isUpcoming ? 'No upcoming orders' : 'No previous orders',
              style: TextStyle(
                color: const Color(0xFF1D1E20),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              isUpcoming
                  ? 'Your active orders will appear here.'
                  : 'Your completed orders will appear here.',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.45),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required Map<String, dynamic> order,
    required bool showTracking,
    required int index,
  }) {
    final items = order['items'] as List<dynamic>? ?? [];
    final total = _toDouble(order['totalOrder']);
    final status = (order['status'] ?? 'pending').toString();
    final orderId = (order['id'] ?? '').toString();

    final orderCode = orderId.isNotEmpty
        ? 'ORD-${orderId.length > 6 ? orderId.substring(0, 6).toUpperCase() : orderId.toUpperCase()}'
        : 'ORD-2026-${index + 1}';

    final dateFormatted = _formatOrderDate(items);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF1D1E20),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateFormatted,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.42),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _statusChip(status),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFA),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                _miniInfo(
                  title: 'Items',
                  value: '${items.length}',
                  icon: Icons.inventory_2_rounded,
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 1.w,
                  height: 34.h,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                SizedBox(width: 12.w),
                _miniInfo(
                  title: 'Total',
                  value: 'EGP ${total.toStringAsFixed(2)}',
                  icon: Icons.payments_rounded,
                ),
              ],
            ),
          ),
          if (items.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Column(
              children: items
                  .take(3)
                  .map((item) => _orderItemTile(item))
                  .toList(),
            ),
            if (items.length > 3)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  '+${items.length - 3} more item(s)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
          if (showTracking) ...[
            SizedBox(height: 16.h),
            _buildTrackingBar(status),
          ],
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _miniInfo({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.38),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF1D1E20),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderItemTile(dynamic item) {
    final title = (item['title'] ?? 'Product').toString();
    final quantity = item['quantity'] ?? 1;
    final price = _toDouble(item['price']);
    final image = (item['image'] ?? '').toString();

    return Container(
      margin: EdgeInsets.only(bottom: 9.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 52.w,
              height: 52.w,
              color: const Color(0xFFF1F5F4),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.pets_rounded,
                    color: AppColors.primary.withValues(alpha: 0.45),
                    size: 24.sp,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF1D1E20),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty $quantity',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.45),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'EGP ${price.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.25,
        ),
      ),
    );
  }

  Widget _buildTrackingBar(String status) {
    final stages = ['Order', 'Shipped', 'Delivered'];
    final icons = [
      Icons.shopping_cart_rounded,
      Icons.local_shipping_rounded,
      Icons.check_circle_rounded,
    ];

    final currentStage = _currentStage(status);

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 38.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 22.w,
                  right: 22.w,
                  child: Row(
                    children: List.generate(stages.length - 1, (index) {
                      final isActive = index < currentStage;

                      return Expanded(
                        child: Container(
                          height: 3.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(stages.length, (index) {
                    final isActive = index <= currentStage;

                    return Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.primary
                            : Colors.grey.shade200,
                        boxShadow: isActive
                            ? [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.18),
                            blurRadius: 10.r,
                            offset: Offset(0, 5.h),
                          ),
                        ]
                            : [],
                      ),
                      child: Icon(
                        icons[index],
                        size: 18.sp,
                        color: isActive ? Colors.white : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(stages.length, (index) {
              final isActive = index <= currentStage;

              return Text(
                stages[index],
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: isActive ? AppColors.primary : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  int _currentStage(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
        return 1;
      case 'delivered':
        return 2;
      default:
        return 0;
    }
  }

  String _formatOrderDate(List<dynamic> items) {
    try {
      if (items.isEmpty || items.first['createdAt'] == null) {
        return 'Unknown date';
      }

      return DateFormat(
        'MMM d, yyyy',
      ).format(DateTime.parse(items.first['createdAt'].toString()));
    } catch (_) {
      return 'Unknown date';
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}