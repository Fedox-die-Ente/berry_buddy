import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notifications/notification_bloc.dart';
import '../../blocs/notifications/notification_event.dart';
import '../../blocs/notifications/notification_state.dart';

class NotificationWidget extends StatefulWidget {
  final String _userId;

  NotificationWidget({required String userId}) : _userId = userId;

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc(userId: widget._userId);
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
                          backgroundColor:
                              const Color.fromRGBO(82, 3, 128, 0.5),
                        ),
                        onPressed: () {
                          _notificationBloc.add(ClearNotifications());
                        },
                        child: const Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  );
                }

                return Card(
                  elevation: 5,
                  color: const Color.fromRGBO(82, 3, 128, 0.6),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        _notificationBloc
                            .add(RemoveNotification(index: index - 1));
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
                  return List.generate(length,
                          (index) => alphabet[random.nextInt(alphabet.length)])
                      .join();
                }

                _notificationBloc
                    .add(AddNotification(notification: generateRandomString()));
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
