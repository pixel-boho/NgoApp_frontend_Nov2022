import 'package:intl/intl.dart';

class DateHelper{

  static String getFormattedDateTimeFromTimestamp(var timestamp,
      {needTime = false, bool isUtc=false}) {
    if (timestamp == null) return '';
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp,isUtc:isUtc);
    var formatter = DateFormat(needTime ? 'dd-MMM-yyyy h:mm a' : 'dd MMM yyyy');
    return formatter.format(date);
  }

  static String getFormattedDateTimeString(DateTime dt, String format) {
    var formatter = DateFormat(format);
    return formatter.format(dt);
  }

  static String formatStringDateTime(String strDt,
      {String parseFormat, String toFormat}) {
    DateTime dateTime = parseDateTime(strDt, parseFormat);
    return getFormattedDateTimeString(dateTime, toFormat==null?parseFormat:toFormat);
  }

  static DateTime parseDateTime(String strDt, String format) {
    return DateFormat(format).parse(strDt);
  }

  static DateTime getDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}