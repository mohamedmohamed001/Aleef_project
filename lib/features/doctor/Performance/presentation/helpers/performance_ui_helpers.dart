import 'package:flutter/material.dart';

String capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

Color appointmentStatusColor(String status) {
  switch (status) {
    case 'completed':
      return const Color(0xff2F80ED);
    case 'cancelled':
      return const Color(0xffE5484D);
    case 'pending':
      return const Color(0xffE1A514);
    default:
      return const Color(0xff19D58B);
  }
}

Color transactionAmountColor(double amount) {
  if (amount > 0) return const Color(0xff19D58B);
  if (amount < 0) return const Color(0xffE5484D);
  return const Color(0xffE1A514);
}

String amountSign(double amount) {
  if (amount > 0) return '+';
  if (amount < 0) return '-';
  return '';
}