import 'package:intl/intl.dart';

String getDateTime(String? inputString) {
  if (inputString == null || inputString.isEmpty) {
    return '';
  } else {

    String isoDate = inputString;
    DateTime dateTime = DateTime.parse(isoDate);
    DateTime localDateTime = dateTime.toLocal();

    String formattedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(localDateTime);
    return formattedDate.toString();
    // DateTime parseDate =
    //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(inputString);
    // var inputDate = DateTime.parse(parseDate.toString());
    // var outputFormat = DateFormat('dd MMM yyyy, hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    //
    // return outputDate.toString();
  }
}
