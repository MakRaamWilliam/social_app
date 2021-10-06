abstract class SocialRegistersStates {}

class SocialRegisterInitialState extends SocialRegistersStates {}

class SocialRegisterLoadingState extends SocialRegistersStates {}

class SocialRegisterSuccessState extends SocialRegistersStates
{
}

class SocialRegisterErrorState extends SocialRegistersStates
{
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialChangePasswordVisibilityState extends SocialRegistersStates {}
