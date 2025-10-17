abstract class LoginState {
  final bool isRememberMeChecked;
  const LoginState({this.isRememberMeChecked = false});
}

class LoginInitial extends LoginState {
  const LoginInitial({bool isRememberMeChecked = false})
      : super(isRememberMeChecked: isRememberMeChecked);
}

class LoginLoading extends LoginState {
  const LoginLoading({required bool isRememberMeChecked})
      : super(isRememberMeChecked: isRememberMeChecked);
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required bool isRememberMeChecked})
      : super(isRememberMeChecked: isRememberMeChecked);
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error, required bool isRememberMeChecked})
      : super(isRememberMeChecked: isRememberMeChecked);
}