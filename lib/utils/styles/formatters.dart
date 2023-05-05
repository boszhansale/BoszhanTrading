import 'package:intl/intl.dart';

class Formatters {
  static String mainTime(DateTime dateTime) {
    return DateFormat("hh:mm a").format(dateTime.toLocal());
  }

  static String callsScheduledDateTime(DateTime dateTime) {
    return DateFormat(r'''MMM d 'at' hh:mm a''').format(dateTime.toLocal());
  }

  static String callsDateTime(DateTime dateTime) {
    return DateFormat("MMM d, hh:mm a").format(dateTime.toLocal());
  }

  static String mainDateAndTime(DateTime dateTime) {
    return DateFormat('MM/dd/yy, hh:mm a').format(dateTime.toLocal());
  }

  static String mainOnlyDate(DateTime dateTime) {
    return DateFormat('MM/dd/yy').format(dateTime.toLocal());
  }

  static String scheduleDayOfWeek(DateTime dateTime) {
    return DateFormat('EEE').format(dateTime.toLocal());
  }

  static String scheduleMonthYear(DateTime dateTime) {
    return DateFormat('MMM yyyy').format(dateTime.toLocal());
  }

  static String scheduleMonthDayYear(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime.toLocal());
  }

  // static String nameFormatter(String? lastName, String? firstName, S lang) {
  //   final name = ((lastName ?? '') + ' ' + (firstName ?? '')).trim();
  //   if (name.isNotEmpty) return name;
  //   return lang.no_data;
  // }
}
