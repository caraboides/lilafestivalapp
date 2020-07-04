bool isSameDay(DateTime date1, DateTime date2, {Duration offset}) {
  final date = offset != null ? date1.subtract(offset) : date1;
  return date.year == date2.year &&
      date.month == date2.month &&
      date.day == date2.day;
}
