import 'package:intl/intl.dart';

String getDateTime(String? inputString) {
  if (inputString == null || inputString.isEmpty) {
    return '';
  } else {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(inputString);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM yyyy, hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }
}
