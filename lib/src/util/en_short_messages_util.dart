
import 'package:timeago/timeago.dart';

class EnShortMessage implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => 'just now';

  @override
  String aboutAMinute(int minutes) => '1 min ago';

  @override
  String minutes(int minutes) => '$minutes min ago';

  @override
  String aboutAnHour(int minutes) => '1 h ago';

  @override
  String hours(int hours) => '$hours h ago';

  @override
  String aDay(int hours) => '1 d ago';

  @override
  String days(int days) => '$days ds ago';

  @override
  String aboutAMonth(int days) => '1 mo';

  @override
  String months(int months) => '$months mos ago';

  @override
  String aboutAYear(int year) => '1 yr ago';

  @override
  String years(int years) => '$years yrs ago';

  @override
  String wordSeparator() => ' ';
}
