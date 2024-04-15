bool validateQuantity(String quantity) {
  String pattern = r'^[1-9][0-9]*$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(quantity);
}