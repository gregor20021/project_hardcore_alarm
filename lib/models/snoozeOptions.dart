class SnoozeOptions {
  int minutes;
  int repeat;
  int decreaseMinutesPerSnooze;

  SnoozeOptions({
    required this.minutes,
    required this.repeat,
    required this.decreaseMinutesPerSnooze,
  });

  factory SnoozeOptions.fromJson(Map<String, dynamic> json) {
    return SnoozeOptions(
      minutes: json['minutes'],
      repeat: json['repeat'],
      decreaseMinutesPerSnooze: json['decreaseMinutesPerSnooze'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minutes': minutes,
      'repeat': repeat,
      'decreaseMinutesPerSnooze': decreaseMinutesPerSnooze,
    };
  }
}