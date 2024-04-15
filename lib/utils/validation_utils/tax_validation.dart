bool validateTax(String tax) {
  // Regular expression to match valid tax rate format with optional decimal
  String pattern = r'^\d+(\.\d{1,2})?$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(tax);
}