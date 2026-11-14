import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String to12HoursFormat() {
    debugPrint('212121 $this');
    int hour = int.parse(split(':')[0]);
    int minute = int.parse(split(':')[1]);

    return '${(hour > 9) ? '$hour' : '0$hour'}:${(minute > 9) ? '$minute' : '0$minute'} ${hour < 12 ? 'AM' : 'PM'}';
  }
}
