import 'dart:convert';
import 'package:aleef/features/store/presentation/pages/checkout_screen.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final storage = const FlutterSecureStorage();
  double subtotalServer = 0.0;
  double deliveryServer = 0.0;
  double totalServer = 0.0;

  @override
  void initState() {
    super.initState();
    calculateCartFromApi();
  }

  Future<void> calculateCartFromApi() async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final url = Uri.parse('${ApiConstant.baseUrl}/products/calculate-cart');
    final token = await storage.read(key: "token");

    final body = {
      "cart": storeProvider.cartItems.map((item) {
        return {
          "productId": item.id,
          "quantity": storeProvider.itemQuantities[item.id.toString()] ?? 1,
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          subtotalServer = (data['subTotal'] ?? 0).toDouble();
          deliveryServer = (data['delivery'] ?? 0).toDouble();
          totalServer = subtotalServer + deliveryServer;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Color(0xFF1D1E20),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${storeProvider.cartItems.length}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: storeProvider.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: storeProvider.cartItems.length,
              itemBuilder: (context, index) {
                final product = storeProvider.cartItems[index];
                final currentQuantity =
                    storeProvider.itemQuantities[product.id.toString()] ?? 1;

                return _buildCartItem(
                  product: product,
                  quantity: currentQuantity,
                  storeProvider: storeProvider,
                );
              },
            ),
          ),
          _buildCheckoutSection(
            subtotalServer,
            deliveryServer,
            totalServer,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required dynamic product,
    required int quantity,
    required StoreProvider storeProvider,
  }) {
    final int remainingStock = (product.stock - quantity).clamp(0, product.stock);
    final bool canIncrease = remainingStock > 0;
    final bool canDecrease = quantity > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                product.thumbnail.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1E20),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "EGP ${product.finalPrice}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  canIncrease
                      ? "Only $remainingStock more available"
                      : "Max stock reached",
                  style: TextStyle(
                    color: canIncrease ? Colors.grey : Colors.orange,
                    fontSize: 12,
                    fontWeight:
                    canIncrease ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuantityBtn(
                      Icons.remove,
                      isEnabled: canDecrease,
                      onTap: () {
                        storeProvider.decrementQuantity(product.id.toString());
                        calculateCartFromApi();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          "$quantity",
                          key: ValueKey(quantity),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    _buildQuantityBtn(
                      Icons.add,
                      isPrimary: true,
                      isEnabled: canIncrease,
                      onTap: () {
                        if (!canIncrease) return;

                        storeProvider.incrementCartQuantity(
                          product.id.toString(),
                        );
                        calculateCartFromApi();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              storeProvider.removeFromCart(product.id.toString());
              calculateCartFromApi();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(
      IconData icon, {
        bool isPrimary = false,
        bool isEnabled = true,
        required VoidCallback onTap,
      }) {
    final Color bgColor = !isEnabled
        ? Colors.grey.shade200
        : isPrimary
        ? AppColors.primary
        : Colors.white;

    final Color borderColor = !isEnabled
        ? Colors.grey.shade300
        : isPrimary
        ? AppColors.primary
        : const Color(0xFFE0E0E0);

    final Color iconColor = !isEnabled
        ? Colors.grey
        : isPrimary
        ? Colors.white
        : Colors.black;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isEnabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(double subtotal, double delivery, double total) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow("Subtotal", "EGP ${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 10),
          _buildSummaryRow("Delivery Fee", "EGP ${delivery.toStringAsFixed(2)}"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          _buildSummaryRow(
            "Total",
            "EGP ${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF1D1E20) : AppColors.hint,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1D1E20),
            fontSize: isTotal ? 20 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}