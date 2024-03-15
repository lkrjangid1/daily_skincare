class Utils {
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int getTodayTimestamp() {
    return DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)
        .millisecondsSinceEpoch;
  }

  static int get30DaysBeforeTimestamp() {
    DateTime d = DateTime.now().subtract(const Duration(days: 30));
    return DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;
  }

  static int getNDaysBeforeTimestamp(int n) {
    DateTime d = DateTime.now().subtract(Duration(days: n));
    return DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;
  }
}
