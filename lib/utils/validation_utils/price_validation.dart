bool validatePrice(String price) {
  // Regular expression to match valid price format with optional decimal
  String pattern = r'^\d+(\.\d{1,2})?$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(price);
}