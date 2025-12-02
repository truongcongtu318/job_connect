/// String extension methods
extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number (Vietnamese format)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
    return phoneRegex.hasMatch(this);
  }
}

/// DateTime extension methods
extension DateTimeExtension on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is in the past
  bool get isPast {
    return isBefore(DateTime.now());
  }

  /// Check if date is in the future
  bool get isFuture {
    return isAfter(DateTime.now());
  }
}

/// Num extension for formatting
extension NumExtension on num {
  /// Format number to Vietnamese currency (VND)
  String toVnd() {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)} tỷ VND';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)} triệu VND';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(0)} nghìn VND';
    } else {
      return '$this VND';
    }
  }
}
