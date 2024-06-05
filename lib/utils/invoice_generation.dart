import 'dart:math';
import 'package:intl/intl.dart';

String generateRandomInvoiceNumber(String phoneNumber) {
  // Get current datetime
  DateTime now = DateTime.now();
  // Format datetime
  String formattedDate = DateFormat('HHmmss').format(now);
  // Extract last four digits of phone number
  String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);
  // Combine all parts to form filename
  String invoiceNo = '$formattedDate$lastFourDigits';

  return invoiceNo;
}

//last 4 digit phonenumber + 4 mmss