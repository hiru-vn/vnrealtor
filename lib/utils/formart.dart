import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Formart {
  static toVNDCurency(double value, {hasUnit = true}) {
    if (value == null) return '0 VND';
    final formatter = NumberFormat("#,##0");
    String newValue = formatter.format(value);
    return newValue + (hasUnit ? ' VND' : '');
  }

  static toUSDCurency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String newValue = formatter.format(value);
    return newValue;
  }

  static String timeAgo(DateTime time) {
    if (time == null) return null;
    return timeago.format(time, locale: 'vi');
  }

  static String timeByDay(DateTime time) {
    if (time == null) return null;
    DateTime now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      DateFormat format = DateFormat("hh:mm a");
      return format.format(time);
    } else
      return timeAgo(time);
  }

  static String timeByDayVi(DateTime dateTime) {
    final messages = Mms();

    DateTime dateTimeNow = DateTime.now();
    final elapsed = dateTimeNow.difference(dateTime).inMilliseconds;

    if (elapsed == 0) {
      return messages.empty();
    }

    String prefix, suffix;

    prefix = messages.prefixAgo();
    suffix = messages.suffixAgo();

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = messages.lessThanOneMinute(seconds.round());
    } else if (seconds < 90) {
      result = messages.aboutAMinute(minutes.round());
    } else if (minutes < 45) {
      result = messages.minutes(minutes.round());
    } else if (minutes < 90) {
      result = messages.aboutAnHour(minutes.round());
    } else if (hours < 24) {
      result = messages.hours(hours.round());
    } else if (hours < 48) {
      result = messages.aDay(hours.round());
    } else if (days < 30) {
      result = messages.days(days.round());
    } else if (days < 60) {
      result = messages.aboutAMonth(days.round());
    } else if (days < 365) {
      result = messages.months(months.round());
    } else if (years < 2) {
      result = messages.aboutAYear(months.round());
    } else {
      result = messages.years(years.round());
    }

    return [prefix, result, suffix]
        .where((str) => str != null && str.isNotEmpty)
        .join(messages.wordSeparator());
  }

  static String timeByDayViShort(DateTime dateTime) {
    final messages = MmsShort();

    DateTime dateTimeNow = DateTime.now();
    final elapsed = dateTimeNow.difference(dateTime).inMilliseconds;

    if (elapsed == 0) {
      return messages.empty();
    }

    String prefix, suffix;

    prefix = messages.prefixAgo();
    suffix = messages.suffixAgo();

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = messages.lessThanOneMinute(seconds.round());
    } else if (seconds < 90) {
      result = messages.aboutAMinute(minutes.round());
    } else if (minutes < 45) {
      result = messages.minutes(minutes.round());
    } else if (minutes < 90) {
      result = messages.aboutAnHour(minutes.round());
    } else if (hours < 24) {
      result = messages.hours(hours.round());
    } else if (hours < 48) {
      result = messages.aDay(hours.round());
    } else if (days < 30) {
      result = messages.days(days.round());
    } else if (days < 60) {
      result = messages.aboutAMonth(days.round());
    } else if (days < 365) {
      result = messages.months(months.round());
    } else if (years < 2) {
      result = messages.aboutAYear(months.round());
    } else {
      result = messages.years(years.round());
    }

    return [prefix, result, suffix]
        .where((str) => str != null && str.isNotEmpty)
        .join(messages.wordSeparator());
  }

  static double toFixedDouble(double value, int digit) {
    return num.parse(value.toStringAsFixed(digit));
  }

  static String formatToDateTime(DateTime date) {
    if (date == null) return null;
    return '${formatToDate(date)} ${formatToTime(date)}';
  }

  static String formatToDate(DateTime date, {String seperateChar = '/'}) {
    if (date == null) return null;
    return '${date.day}$seperateChar${date.month}$seperateChar${date.year}';
  }

  static String formatToTime(DateTime time) {
    if (time == null) return null;
    return '${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}';
  }

  static String formatNumber(double number) {
    final numberFormater = NumberFormat("#,##0.00", "en_US");
    return numberFormater.format(number);
  }

  static String formatErrFirebaseLoginToString(String err) {
    String message = "";
    switch (err) {
      case "missing-client-identifier":
        message = "Thiếu mã SHA-1 trên thiết bị";
        break;
      case "ERROR_ARGUMENT_ERROR":
        message = "Vui lòng nhập đầy đủ dữ liệu";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        message = "Phương thức đăng nhập này chưa được cho phép";
        break;
      case "ERROR_USER_DISABLED":
        message = "Tài khoản này đã bị khoá";
        break;
      case "ERROR_INVALID_EMAIL":
        message = "Định dạng Email không đúng";
        break;
      case "ERROR_USER_NOT_FOUND":
        message = "Tài khoản không tồn tại";
        break;
      case "ERROR_WRONG_PASSWORD":
        message = "Sai mật khẩu, vui lòng nhập lại";
        break;
      case "too-many-requests":
        message = "Quá giới hạn số lần đăng nhập, xin hãy thử lại sau vài phút";
        break;
      default:
        print(err);
        message = "Lỗi Đăng Nhập";
        return err;
    }
    return message;
  }
}

class Mms {
  String prefixAgo() => '';
  String prefixFromNow() => 'in';
  String suffixAgo() => 'trước';
  String suffixFromNow() => '';
  String lessThanOneMinute(int seconds) => 'vài giây';
  String aboutAMinute(int minutes) => 'một phút';
  String minutes(int minutes) => '$minutes phút';
  String aboutAnHour(int minutes) => 'một giờ';
  String hours(int hours) => '$hours giờ';
  String aDay(int hours) => 'một ngày';
  String days(int days) => '$days ngày';
  String aboutAMonth(int days) => 'một tháng';
  String months(int months) => '$months tháng';
  String aboutAYear(int year) => 'một năm';
  String years(int years) => '$years năm';
  String wordSeparator() => ' ';
  String empty() => 'Chưa có tin nhắn nào';
}

class MmsShort {
  String prefixAgo() => '';
  String prefixFromNow() => 'in';
  String suffixAgo() => '';
  String suffixFromNow() => '';
  String lessThanOneMinute(int seconds) => 'vừa xong';
  String aboutAMinute(int minutes) => '1p';
  String minutes(int minutes) => '${minutes}p';
  String aboutAnHour(int minutes) => '1h';
  String hours(int hours) => '${hours}h';
  String aDay(int hours) => '1d';
  String days(int days) => '${days}d';
  String aboutAMonth(int days) => '1mo';
  String months(int months) => '${months}mos';
  String aboutAYear(int year) => '1yr';
  String years(int years) => '${years}yrs';
  String wordSeparator() => ' ';
  String empty() => 'Chưa có tin nhắn nào';
}
