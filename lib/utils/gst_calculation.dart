double calculatePriceWithGst(int count,double originalPrice,double gstRate) {
  // Calculating the price including GST
  double gstAmount = originalPrice * count * (gstRate / 100);
  double totalPrice = (originalPrice * count) + gstAmount;
  return totalPrice;
}