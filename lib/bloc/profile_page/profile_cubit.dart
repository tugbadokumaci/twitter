import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  ProfileCubit({
    required ProfileRepository repo,
  })  : _repo = repo,
        super(ProfileInitial());
}
