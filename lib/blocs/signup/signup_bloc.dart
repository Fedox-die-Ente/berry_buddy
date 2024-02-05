import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../repositories/userRepository.dart';
import '../../ui/validators.dart';
import './bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpState.empty());

  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<Transition<SignUpEvent, SignUpState>> transformEvents(
    Stream<SignUpEvent> events,
    TransitionFunction<SignUpEvent, SignUpState> transitionFn,
  ) {
    final nonDebounceStream = events
        .where((event) => !(event is EmailChanged || event is PasswordChanged));

    final debounceStream = events
        .where((event) => event is EmailChanged || event is PasswordChanged)
        .debounceTime(const Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
      isPasswordValid: false,
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
        isPasswordValid: Validators.isValidPassword(password),
        isEmailValid: false);
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    yield SignUpState.loading();
    print("wtf");
    try {
      if (await _userRepository.signUpWithEmail(email, password)) {
        yield SignUpState.success();
      } else {
        yield SignUpState.failure();
      }
    } catch (_) {
      SignUpState.failure();
    }
  }
}
