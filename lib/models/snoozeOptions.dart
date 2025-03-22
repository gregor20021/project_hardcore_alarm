class SnoozeOptions {
  int minutes;
  int repeat;
  bool vibrate;
  int decreaseMinutesPerSnooze;

  SnoozeOptions({
    required this.minutes,
    required this.repeat,
    required this.decreaseMinutesPerSnooze,
    required this.vibrate,
  });

  factory SnoozeOptions.fromJson(Map<String, dynamic> json) {
    return SnoozeOptions(
      minutes: json['minutes'],
      repeat: json['repeat'],
      vibrate: json['vibrate'],
      decreaseMinutesPerSnooze: json['decreaseMinutesPerSnooze'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minutes': minutes,
      'repeat': repeat,
      'vibrate': vibrate,
      'decreaseMinutesPerSnooze': decreaseMinutesPerSnooze,
    };
  }
}