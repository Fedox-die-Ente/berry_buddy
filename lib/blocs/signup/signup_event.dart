import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

class PasswordChanged extends SignUpEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}

class Submitted extends SignUpEvent {
  final String email;
  final String password;

  const Submitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpWithCredentialsPressed extends SignUpEvent {
  final String email;
  final String password;

  const SignUpWithCredentialsPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}