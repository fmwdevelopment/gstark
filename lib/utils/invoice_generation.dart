import 'dart:math';
import 'package:intl/intl.dart';

String generateRandomInvoiceNumber(String phoneNumber) {
  // Get current datetime
  DateTime now = DateTime.now();
  // Format datetime
  String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
  // Extract last four digits of phone number
  String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);
  // Generate random string
  String randomString = Random().nextInt(10000).toString().padLeft(4, '0');
  // Combine all parts to form filename
  String invoiceNo = '$formattedDate$lastFourDigits$randomString';

  return invoiceNo;
}