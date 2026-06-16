import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'checkout_items_list.dart';
import 'checkout_label.dart';
import 'credit_card_preview.dart';
import 'cut_circle.dart';
import 'dotted_divider.dart';
import 'payment_method_pill.dart';
import 'receipt_row.dart';
import 'ticket_header.dart';
import 'ticket_text_field.dart';

class TicketCard extends StatelessWidget {
  final StoreProvider storeProvider;
  final double subtotal;
  final double total;
  final double delivery;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController phoneController;
  final TextEditingController cardNumberController;
  final TextEditingController cardNameController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final FocusNode cvvFocusNode;
  final String selectedPaymentMethod;
  final bool isLoading;
  final Function(String) onPaymentMethodChanged;
  final VoidCallback onPlaceOrder;

  const TicketCard({
    super.key,
    required this.storeProvider,
    required this.subtotal,
    required this.total,
    required this.delivery,
    required this.addressController,
    required this.cityController,
    required this.phoneController,
    required this.cardNumberController,
    required this.cardNameController,
    required this.expiryController,
    required this.cvvController,
    required this.cvvFocusNode,
    required this.selectedPaymentMethod,
    required this.isLoading,
    required this.onPaymentMethodChanged,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TicketHeader(),
              SizedBox(height: 18.h),
              const DottedDivider(),
              SizedBox(height: 18.h),

              const CheckoutLabel(text: "Delivery To"),
              SizedBox(height: 12.h),
              TicketTextField(
                controller: addressController,
                label: "Street address",
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TicketTextField(
                      controller: cityController,
                      label: "City",
                      icon: Icons.location_city_outlined,
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TicketTextField(
                      controller: phoneController,
                      label: "Phone",
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22.h),
              const CheckoutLabel(text: "Payment Stamp"),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: PaymentMethodPill(
                      value: "cash",
                      title: "Cash",
                      icon: Icons.payments_outlined,
                      isSelected: selectedPaymentMethod == "cash",
                      onTap: () => onPaymentMethodChanged("cash"),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: PaymentMethodPill(
                      value: "credit",
                      title: "Card",
                      icon: Icons.credit_card_rounded,
                      isSelected: selectedPaymentMethod == "credit",
                      onTap: () => onPaymentMethodChanged("credit"),
                    ),
                  ),
                ],
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: selectedPaymentMethod == "credit"
                    ? Padding(
                  key: const ValueKey("credit_card_form"),
                  padding: EdgeInsets.only(top: 16.h),
                  child: Column(
                    children: [
                      CreditCardPreview(
                        cardNumber: cardNumberController.text.trim(),
                        cardHolder: cardNameController.text.trim(),
                        expiryDate: expiryController.text.trim(),
                        cvv: cvvController.text.trim(),
                        showBack: cvvFocusNode.hasFocus,
                      ),
                      SizedBox(height: 14.h),
                      TicketTextField(
                        controller: cardNumberController,
                        label: "1234 5678 9012 3456",
                        icon: Icons.credit_card_rounded,
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                      ),
                      SizedBox(height: 10.h),
                      TicketTextField(
                        controller: cardNameController,
                        label: "Card holder name",
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: TicketTextField(
                              controller: expiryController,
                              label: "MM/YY",
                              icon: Icons.date_range_rounded,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TicketTextField(
                              controller: cvvController,
                              focusNode: cvvFocusNode,
                              label: "CVV",
                              icon: Icons.lock_outline_rounded,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: 22.h),
              const DottedDivider(),
              SizedBox(height: 18.h),

              const CheckoutLabel(text: "Items"),
              SizedBox(height: 12.h),
              CheckoutItemsList(storeProvider: storeProvider),

              SizedBox(height: 16.h),
              const DottedDivider(),
              SizedBox(height: 16.h),

              ReceiptRow(title: "Subtotal", value: subtotal),
              SizedBox(height: 10.h),
              ReceiptRow(title: "Delivery", value: delivery),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: ReceiptRow(title: "Total", value: total, isTotal: true),
              ),

              SizedBox(height: 18.h),

              SizedBox(
                width: double.infinity,
                height: 58.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.45),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 23.h,
                    width: 23.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4.w,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(left: -15.w, top: 92.h, child: const CutCircle()),
        Positioned(right: -15.w, top: 92.h, child: const CutCircle()),
      ],
    );
  }
}