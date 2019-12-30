
class SettingsEvent{}

class ToggleNotifications extends SettingsEvent{
  final bool hasNotify;
  ToggleNotifications(bool notify): hasNotify = notify;
}

class ChangeFontSize extends SettingsEvent{
  final int fontSize;
  ChangeFontSize(int size): fontSize = size;
}

class ChangeVolume extends SettingsEvent {
  final double volume;
  ChangeVolume(double volume): volume = volume;
}