import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Banned extends StatefulWidget {
  @override
  _BannedState createState() => _BannedState();
}

class _BannedState extends State<Banned> {
  @override
  Widget build(BuildContext context) {
    AudioPlayer().play(UrlSource(
        "https://ia601300.us.archive.org/9/items/banned_202402/banned.mp3"));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.red],
            // Hintergrund mit Schwarz-Rot-Gradienten
            begin: Alignment.topCenter,
            // Gradient startet oben
            end: Alignment.bottomCenter, // und endet unten
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "BANNED",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "You have been banned for violating the rules.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
