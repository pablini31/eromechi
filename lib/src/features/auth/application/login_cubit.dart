import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  void toggleRememberMe(bool newValue) {
    if (state is LoginInitial) {
      emit(LoginInitial(isRememberMeChecked: newValue));
    } else if (state is LoginLoading) {
      emit(LoginLoading(isRememberMeChecked: newValue));
    } else if (state is LoginSuccess) {
      emit(LoginSuccess(isRememberMeChecked: newValue));
    } else if (state is LoginFailure) {
      final currentState = state as LoginFailure;
      emit(LoginFailure(
          error: currentState.error, isRememberMeChecked: newValue));
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading(isRememberMeChecked: state.isRememberMeChecked));
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'erick@romero.com' && password == '123456') {
      emit(LoginSuccess(isRememberMeChecked: state.isRememberMeChecked));
    } else {
      emit(LoginFailure(
          error: 'Invalid credentials',
          isRememberMeChecked: state.isRememberMeChecked));
    }
  }
}
