import 'package:intl/intl.dart';

class DateFormatter {
  // Private constructor to prevent instantiation
  DateFormatter._();

  // Format date as 'MMM dd, yyyy' (e.g. Jan 01, 2023)
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as 'MMM dd, yyyy HH:mm' (e.g. Jan 01, 2023 14:30)
  static String formatDateWithTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  // Format relative date (e.g. Today, Yesterday, 2 days ago)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final difference = today.difference(dateOnly).inDays;
      if (difference < 7) {
        return '$difference days ago';
      } else {
        return formatDate(date);
      }
    }
  }

  // Format time as 'HH:mm' (e.g. 14:30)
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}