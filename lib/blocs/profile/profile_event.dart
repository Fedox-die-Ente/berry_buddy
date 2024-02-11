import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ProfileEvent {
  final File photo;

  PhotoChanged({required this.photo});

  @override
  List<Object> get props => [photo];
}

class AgeChanged extends ProfileEvent {
  final DateTime age;

  AgeChanged({required this.age});

  @override
  List<Object> get props => [age];
}

class GenderChanged extends ProfileEvent {
  final String gender;

  GenderChanged({required this.gender});

  @override
  List<Object> get props => [gender];
}

class InterestedInChanged extends ProfileEvent {
  final String interestedIn;

  InterestedInChanged({required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class LocationChanged extends ProfileEvent {
  final Position position;

  const LocationChanged({required this.position});

  @override
  List<Object> get props => [position];
}

class Submitted extends ProfileEvent {
  final String name, gender;
  final DateTime age;
  final Position position;
  final Uint8List photo;

  const Submitted(
      {required this.name,
      required this.gender,
      required this.age,
      required this.position,
      required this.photo});

  @override
  List<Object> get props => [position, name, age, gender, photo];
}
