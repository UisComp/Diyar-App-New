import 'package:easy_localization/easy_localization.dart';

class AppFormatter {
  static DateFormat dateFormatter() {
    return DateFormat('yyyy-MM-dd');
  }

  static DateFormat unitEventFormatterForSendRequest() {
    return DateFormat('YYYY-MM-DD');
  }

  static DateFormat unitEventDateFormatter() {
    return DateFormat('MMMM d, yyyy');
  }
}
