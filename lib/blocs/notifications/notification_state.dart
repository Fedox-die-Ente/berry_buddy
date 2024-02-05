import 'package:meta/meta.dart';

@immutable
class NotificationState {
  final List<String> notifications;

  const NotificationState({required this.notifications});

  factory NotificationState.initial() {
    return const NotificationState(notifications: []);
  }

  NotificationState copyWith({
    List<String>? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }
}
