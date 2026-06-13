import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/store/presentation/pages/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/theme/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _selectedPaymentMethod = "cash";
  bool _isLoading = false;

  Future<void> placeOrderAction() async {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in address and phone"),
          backgroundColor: Colors.red,
            duration: const Duration(seconds: 2)
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final storeProvider = context.read<StoreProvider>();
    final cartItems = storeProvider.cartItems;
    final String? token = await _storage.read(key: "token");

    final url = Uri.parse("${ApiConstant.baseUrl}/orders/");

    final cartData = cartItems.map((product) {
      final qty = storeProvider.itemQuantities[product.id.toString()] ?? 1;
      return {
        "productId": product.id,
        "quantity": qty,
        "price": product.finalPrice,
      };
    }).toList();

    final body = {
      "cart": cartData,
      "shippingAddress": {
        "address": _addressController.text,
        "city": _cityController.text,
        "phone": _phoneController.text,
      },
      "paymentMethod": _selectedPaymentMethod,
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        storeProvider.cartItems.clear();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order Placed Successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessView()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds:3),
            backgroundColor: Colors.red,
            content: Text(
              "Error: ${jsonDecode(response.body)['message'] ?? 'Failed'}",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Exception: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
@override
  void dispose() {
    // TODO: implement dispose

    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final cartItems = storeProvider.cartItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Address",
              style: AppTextStyles.title16SemiBold.copyWith(
                fontSize: 20
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _addressController,
              "Street Address",
              Icons.location_on_outlined,
              TextInputType.streetAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _cityController,
              "City",
              Icons.location_city_outlined,
              TextInputType.streetAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _phoneController,
              "Phone Number",
              Icons.phone_android_outlined,
              TextInputType.phone,
            ),
            const SizedBox(height: 30),
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPaymentOption(
              "cash",
              "Cash on Delivery",
              Icons.money,
              "Pay when you receive",
            ),
            const SizedBox(height: 10),
            _buildPaymentOption(
              "credit",
              "Credit Card",
              Icons.credit_card,
              "Pay with credit card",
            ),
            const SizedBox(height: 30),
            _buildOrderSummary(cartItems, storeProvider),
            const SizedBox(height: 30),
            _buildOrderTotal(storeProvider.totalPrice),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : placeOrderAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  TextInputType? keyboardType,
  ) {
    return TextField(
      keyboardType:keyboardType ,
      controller: controller,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.black),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(List items, StoreProvider storeProvider) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            final qty = storeProvider.itemQuantities[item.id.toString()] ?? 1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.title} (x$qty)",
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    "\$${(item.finalPrice * qty).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderTotal(double subtotal) {
    double delivery = 20.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Subtotal", style: TextStyle(color: Colors.black)),
            Text(
              "\$${subtotal.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Delivery", style: TextStyle(color: Colors.black)),
            Text("\$20.00", style: TextStyle(color: Colors.black)),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "\$${(subtotal + delivery).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
