
class SettingsEvent{}

class ToggleNotifications extends SettingsEvent{
  final bool hasNotify;
  ToggleNotifications(bool notify): hasNotify = notify;
}

class ChangeFontSize extends SettingsEvent{
  final int fontSize;
  ChangeFontSize(int size): fontSize = size;
}