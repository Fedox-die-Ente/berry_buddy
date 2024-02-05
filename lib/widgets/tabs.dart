import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../constants.dart';
import '../ui/pages/matches.dart';
import '../ui/pages/messages.dart';
import '../ui/pages/notifications.dart';
import '../ui/pages/search.dart';
import '../ui/pages/sma.dart';



class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SMA(
        userId: userId,
      ),
      SMA(
        userId: userId,
      ),
      // CARD SWIPE
      SMA(
        userId: userId,
      ),
      // MESSAGES
      Messages(
        userId: userId,
      ),
      // Notifications
      Notifications(
        userId: userId,
      ),

    ];

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: kPrimaryColor),
      ),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            title: const Text(
              "Berry Buddy",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              )
            ],
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),

          body: Stack(
            children: [
              TabBarView(
                children: pages,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Colors.deepPurple.shade600,
                        Colors.deepPurple.shade500
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: TabBar(
                    unselectedLabelColor: Colors.white38,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.transparent,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    tabs: const <Widget>[
                      Tab(icon: Icon(Icons.person_rounded)),
                      Tab(icon: Icon(Icons.bolt_rounded)),
                      Tab(icon: Icon(Icons.swipe_rounded)),
                      Tab(icon: Icon(Icons.message_rounded)),
                      Tab(icon: Icon(Icons.notifications_active_rounded)),
                    ],
                    indicatorPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}