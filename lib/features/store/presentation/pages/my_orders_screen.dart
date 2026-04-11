import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1E20)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "My Orders",
            style: TextStyle(
              color: Color(0xFF1D1E20),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.hint,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Upcoming Orders"),
              Tab(text: "Previous Orders"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(isUpcoming: true),
            _buildOrdersList(isUpcoming: false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList({required bool isUpcoming}) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: isUpcoming ? 1 : 2,
      itemBuilder: (context, index) {
        return _buildOrderCard(
          orderId: isUpcoming ? "ORD-2026-001" : "ORD-2026-002",
          date: isUpcoming ? "March 3, 2026" : "February 20, 2026",
          status: isUpcoming ? "Shipped" : "Delivered",
          price: isUpcoming ? "64.49" : "32.00",
          isUpcoming: isUpcoming,
          isCancelled: !isUpcoming && index == 1,
        );
      },
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required String status,
    required String price,
    required bool isUpcoming,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF5F6F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Color(0xFF1D1E20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                isCancelled ? "Cancelled" : status,
                style: TextStyle(
                  color: isCancelled
                      ? Colors.redAccent
                      : (status == "Shipped" ? Colors.blue : AppColors.primary),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(date, style: TextStyle(color: AppColors.hint, fontSize: 13)),
          const Divider(height: 30, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "2 items • \$$price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1E20),
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "View Order Details",
                      style: TextStyle(color: AppColors.hint, fontSize: 13),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.hint, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
