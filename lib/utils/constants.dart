class Constants {
  const Constants();

  // FILE NAMES
  static String myScheduleAppStorageFileName(String id) =>
      'my_schedule_$id.json';
  static const String myScheduleAppStorageLegacyFileName = 'my_schedule.txt';
  static const String bandsAppStorageFileName = 'bands.json';
  static const String bandsAssetFileName = 'assets/bands.json';
  static const String scheduleAppStorageFileName = 'schedule.json';
  static const String scheduleAssetFileName = 'assets/schedule.json';

  // NOTIFICATIONS
  static const String notificationChannelId = 'event_notification';
  static const String notificationIcon = 'notification_icon';
}
