class AuthValidator {

  static String? phone(String? value) {
    final phoneRegex = RegExp(r'^\d{10}$');

    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    if (!phoneRegex.hasMatch(value)) {
      return "Phone number must be 10 digits";
    }

    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return "Verification code is required";
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Code must contain numbers only";
    }

    if (value.length != length) {
      return "Code must be $length digits";
    }

    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }
}