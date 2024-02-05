import 'package:bloc/bloc.dart';
import '../../repositories/userRepository.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  UserRepository _userRepository;

  NotificationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(NotificationState.initial());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is AddNotification) {
      yield* _mapAddNotificationToState(event);
    } else if (event is ClearNotifications) {
      yield* _mapClearNotificationsToState(event);
    } else if (event is RemoveNotification) {
      yield* _mapRemoveNotificationToState(event);
    }
  }

  // Aber ja notifications sollten funktionieren, NUR, idk ob das jz auf user angepasst ist bzw es muss auch noch gespeichert werden i guess
  // local oder in der datenbank idk, das is dein job xd ich mach frontend

  Stream<NotificationState> _mapAddNotificationToState(AddNotification event) async* {
    final List<String> updatedNotifications = List.from(state.notifications)
      ..add(event.notification);

    yield state.copyWith(notifications: updatedNotifications);
  }

  Stream<NotificationState> _mapRemoveNotificationToState(RemoveNotification event) async* {
    final List<String> updatedNotifications = List.from(state.notifications);

    if (event.index >= 0 && event.index < updatedNotifications.length) {
      updatedNotifications.removeAt(event.index);
      yield state.copyWith(notifications: updatedNotifications);
    }
  }

  Stream<NotificationState> _mapClearNotificationsToState(ClearNotifications event) async* {
    yield state.copyWith(notifications: []);
  }
}
