import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/home_page/home_state.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repo;
  final TextEditingController getEmailController = TextEditingController();
  final TextEditingController getPasswordController = TextEditingController();
  // String profilePhoto = '';

  HomeCubit({
    required HomeRepository repo,
  })  : _repo = repo,
        super(HomeInitial());

  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    emit(HomeTabChanged(index: index));
  }

  // Future<bool> getProfilePhotoUrl() async {
  //   final result = await _repo.getProfilePhotoUrl(Constants.USER.userId);

  //   if (result.status == Status.SUCCESS) {
  //     profilePhoto = result.data!;
  //     emit(HomeSuccess());
  //     return true;
  //   } else {
  //     debugPrint(' Home Cubit getProfilePhotoUrl error');
  //     return false;
  //   }
  // }
}
