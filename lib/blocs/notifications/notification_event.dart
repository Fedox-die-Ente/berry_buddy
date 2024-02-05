import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class AddNotification extends NotificationEvent {
  final String notification;

  const AddNotification({required this.notification});

  @override
  List<Object?> get props => [notification];
}

class RemoveNotification extends NotificationEvent {
  final int index;

  const RemoveNotification({required this.index});

  @override
  List<Object?> get props => [index];
}


class ClearNotifications extends NotificationEvent {}
