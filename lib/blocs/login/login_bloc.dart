import 'dart:async';
import 'package:berry_buddy/blocs/authentication/authentication_state.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../repositories/userRepository.dart';
import '../../ui/validators.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
      super(LoginState.empty());

  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events,
      TransitionFunction<LoginEvent, LoginState> transitionFn,
      ) {
    final nonDebounceStream = events.where((event) =>
    !(event is EmailChanged || event is PasswordChanged));

    final debounceStream = events
        .where((event) => event is EmailChanged || event is PasswordChanged)
        .debounceTime(const Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }



  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email), isPasswordValid: false,
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password), isEmailValid: false);
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String? email,
    String? password,
  }) async* {
    yield LoginState.loading();
    try {
      bool signInSuccess = await _userRepository.signInWithEmail(email!, password!);

      if (signInSuccess) {
        print("login success");
        yield LoginState.success();
      } else {
        print("login failed");
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }

}