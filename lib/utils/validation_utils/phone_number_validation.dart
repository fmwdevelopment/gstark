bool validatePhoneNumber(String phoneNumber) {
  // Regular expression for a typical phone number pattern
  // This example assumes a simple 10-digit phone number
  // You may need to adjust the regex for your specific needs
  String pattern = r'^[0-9]{10}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}