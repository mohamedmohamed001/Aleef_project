import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// Global list to store cart items
List<Map<String, dynamic>> cartItems = [];

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    for (var item in cartItems) {
      String priceStr = item['price'].toString().replaceAll('\$', '');
      subtotal += double.parse(priceStr) * item['quantity'];
    }

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
                  "${cartItems.length}",
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
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(
                        cartItems[index]['name'],
                        cartItems[index]['price'].toString().replaceAll(
                          '\$',
                          '',
                        ),
                        cartItems[index]['image'],
                        cartItems[index]['quantity'],
                        index,
                      );
                    },
                  ),
                ),
                _buildCheckoutSection(subtotal),
              ],
            ),
    );
  }

  Widget _buildCartItem(
    String name,
    String price,
    String image,
    int quantity,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1E20),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$$price",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuantityBtn(
                      Icons.remove,
                      onTap: () {
                        setState(() {
                          if (cartItems[index]['quantity'] > 1) {
                            cartItems[index]['quantity']--;
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "$quantity",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildQuantityBtn(
                      Icons.add,
                      isPrimary: true,
                      onTap: () {
                        setState(() {
                          cartItems[index]['quantity']++;
                        });
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
              setState(() {
                cartItems.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(
    IconData icon, {
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPrimary ? AppColors.primary : const Color(0xFFE0E0E0),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(double subtotal) {
    double delivery = 5.00;
    double total = subtotal + delivery;

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
          _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 10),
          _buildSummaryRow("Delivery Fee", "\$${delivery.toStringAsFixed(2)}"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          _buildSummaryRow(
            "Total",
            "\$${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
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
