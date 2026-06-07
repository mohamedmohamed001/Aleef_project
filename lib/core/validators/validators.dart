class Validators {
  Validators._();

  // ========== Name ==========
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  // ========== Email ==========
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
    RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  // ========== Phone ==========
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex =
    RegExp(r'^01[0125][0-9]{8}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid Egyptian phone number';
    }

    return null;
  }

  // ========== Password ==========
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ========== Confirm Password ==========
  static String? validateConfirmPassword(
      String? value,
      String? password,
      ) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ========== Required Text ==========
  static String? validateRequiredField(
      String? value,
      String fieldName,
      ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // ========== Numeric ==========
  static String? validateNumericField(
      String? value,
      String fieldName,
      ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value.trim()) == null) {
      return '$fieldName must be a number';
    }

    return null;
  }

  // ========== OTP ==========
  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }

    if (value.trim().length != 6) {
      return 'Enter a valid 6-digit OTP';
    }

    return null;
  }

  // ========== File ==========
  static String? validateFile(
      dynamic value,
      String fieldName,
      ) {
    if (value == null) {
      return '$fieldName is required';
    }

    return null;
  }
}