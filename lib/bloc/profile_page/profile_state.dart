import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Resource<UserModel> ads;

  ProfileSuccess({required this.ads});
}

class ProfileError extends ProfileState {}
