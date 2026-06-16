import 'package:aleef/features/store/presentation/pages/order_success_view.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/checkout/checkout_status_card.dart';
import '../widgets/checkout/ticket_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FocusNode _cvvFocusNode = FocusNode();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _selectedPaymentMethod = "cash";

  bool _isFormattingCardNumber = false;
  bool _isFormattingExpiry = false;
  bool _isFormattingCvv = false;

  static const double delivery = 20.0;

  @override
  void initState() {
    super.initState();

    _cvvController.addListener(_refresh);
    _cardNameController.addListener(_refresh);

    _cardNumberController.addListener(_formatCardNumber);
    _expiryController.addListener(_formatExpiryDate);
    _cvvController.addListener(_formatCvv);

    _cvvFocusNode.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _formatCardNumber() {
    if (_isFormattingCardNumber) return;

    _isFormattingCardNumber = true;

    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 16 ? digits.substring(0, 16) : digits;

    final buffer = StringBuffer();

    for (int i = 0; i < limitedDigits.length; i++) {
      buffer.write(limitedDigits[i]);

      if ((i + 1) % 4 == 0 && i != limitedDigits.length - 1) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();

    if (_cardNumberController.text != formatted) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    _isFormattingCardNumber = false;
    _refresh();
  }

  void _formatExpiryDate() {
    if (_isFormattingExpiry) return;

    _isFormattingExpiry = true;

    final digits = _expiryController.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 4 ? digits.substring(0, 4) : digits;

    String formatted = limitedDigits;

    if (limitedDigits.length > 2) {
      formatted =
      '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    }

    if (_expiryController.text != formatted) {
      _expiryController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    _isFormattingExpiry = false;
    _refresh();
  }

  void _formatCvv() {
    if (_isFormattingCvv) return;

    _isFormattingCvv = true;

    final digits = _cvvController.text.replaceAll(RegExp(r'\D'), '');
    final formatted = digits.length > 3 ? digits.substring(0, 3) : digits;

    if (_cvvController.text != formatted) {
      _cvvController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    _isFormattingCvv = false;
    _refresh();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> placeOrderAction() async {
    if (_addressController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      _showError("Please fill in address and phone");
      return;
    }

    if (_selectedPaymentMethod == "credit") {
      final cardDigits =
      _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
      final cvvDigits = _cvvController.text.replaceAll(RegExp(r'\D'), '');

      if (cardDigits.length != 16 ||
          _cardNameController.text.trim().isEmpty ||
          _expiryController.text.trim().length != 5 ||
          cvvDigits.length != 3) {
        _showError("Please enter valid card details");
        return;
      }
    }

    final storeProvider = context.read<StoreProvider>();

    final success = await storeProvider.placeOrder(
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      phone: _phoneController.text.trim(),
      paymentMethod: _selectedPaymentMethod,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccessView(),
        ),
      );
    } else {
      _showError(storeProvider.placeOrderError ?? "Failed to place order");
    }
  }

  @override
  void dispose() {
    _cvvFocusNode.removeListener(_refresh);
    _cvvFocusNode.dispose();

    _cvvController.removeListener(_refresh);
    _cardNameController.removeListener(_refresh);

    _cardNumberController.removeListener(_formatCardNumber);
    _expiryController.removeListener(_formatExpiryDate);
    _cvvController.removeListener(_formatCvv);

    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();

    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    final subtotal = storeProvider.totalPrice;
    final total = subtotal + delivery;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF4F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF4F3),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: const Color(0xFF152E2C),
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: IconThemeData(
          color: const Color(0xFF152E2C),
          size: 24.sp,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 28.h),
        child: Column(
          children: [
            const CheckoutStatusCard(),
            SizedBox(height: 18.h),
            TicketCard(
              storeProvider: storeProvider,
              subtotal: subtotal,
              total: total,
              delivery: delivery,
              addressController: _addressController,
              cityController: _cityController,
              phoneController: _phoneController,
              cardNumberController: _cardNumberController,
              cardNameController: _cardNameController,
              expiryController: _expiryController,
              cvvController: _cvvController,
              selectedPaymentMethod: _selectedPaymentMethod,
              isLoading: storeProvider.isPlacingOrder,
              onPaymentMethodChanged: (val) {
                setState(() => _selectedPaymentMethod = val);
              },
              onPlaceOrder: placeOrderAction,
              cvvFocusNode: _cvvFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}