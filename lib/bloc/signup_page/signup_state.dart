abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupStep2 extends SignupState {}

class SignupStep3 extends SignupState {}

class SignupStep4 extends SignupState {}

class SignupStep5 extends SignupState {}

class SignupChoosePhoto extends SignupState {}

class SignupChooseUsername extends SignupState {
  final bool isUsernameValid;

  SignupChooseUsername({required this.isUsernameValid});
}

class SignupChooseBio extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {}
