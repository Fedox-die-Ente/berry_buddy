import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notifications/notification_bloc.dart';
import '../blocs/notifications/notification_event.dart';
import '../blocs/notifications/notification_state.dart';
import '../repositories/userRepository.dart';

class NotificationWidget extends StatefulWidget {
  final UserRepository _userRepository;

  NotificationWidget({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc(userRepository: widget._userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _notificationBloc,
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return Scaffold(
            body: ListView.builder(
              itemCount: state.notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                      ),
                      onPressed: () {
                        _notificationBloc.add(ClearNotifications());
                      },
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ),
                  );
                }

                // Normale Benachrichtigungseinträge
                return Card(
                  elevation: 5,
                  color: Colors.deepPurple.shade500,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      state.notifications[index - 1],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _notificationBloc.add(RemoveNotification(index: index - 1));
                      },
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                String generateRandomString() {
                  const alphabet = 'abcdefghijklmnopqrstuvwxyz';
                  final random = Random();
                  final length = 20;
                  return List.generate(length, (index) => alphabet[random.nextInt(alphabet.length)]).join();
                }

                _notificationBloc.add(AddNotification(notification: generateRandomString()));

              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }
}