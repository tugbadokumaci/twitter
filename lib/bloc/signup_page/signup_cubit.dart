// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/signup_page/signup_state.dart';
import 'package:twitter/bloc/signup_page/signup_repository.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import '../../utils/resource.dart';
import '../../utils/utils.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository _repo;
  SignupCubit({required SignupRepository repo})
      : _repo = repo,
        super(SignupInitial());

  TextEditingController getEmailController = TextEditingController();
  TextEditingController getPasswordController = TextEditingController();

  TextEditingController getNameController = TextEditingController();
  TextEditingController getBirthdayController = TextEditingController();

  TextEditingController getUsernameController = TextEditingController();
  TextEditingController getBioController = TextEditingController();

  bool isUsernameValid = true;
  Uint8List? imageData;
  // List<int> image = [];
  Future<void> signUp(BuildContext context) async {
    DateFormat _dateFormatWithDots = DateFormat('dd.MM.yyyy');
    DateFormat _dateFormatWithoutDots = DateFormat('ddMMyyyy');
    DateTime parsedDate;

    try {
      parsedDate = _dateFormatWithDots.parse(getBirthdayController.text);
    } catch (e) {
      // If parsing with dots fails, try parsing without dots
      parsedDate = _dateFormatWithoutDots.parse(getBirthdayController.text);
    }
    String formattedDate = _dateFormatWithDots.format(parsedDate);

    Resource<String> result =
        await _repo.signUp(getEmailController.text, getPasswordController.text, getNameController.text, formattedDate);
    if (result.status == Status.SUCCESS) {
      // Utils.showCustomDialog(
      //   context: context,
      //   title: 'Sign up Success',
      //   content: 'Sign up Success',
      //   onTap: () {
      //     Navigator.of(context).pop();
      //     emit(SignupChoosePhoto());
      //   },
      // );
      emit(SignupChoosePhoto());
    } else {
      Utils.showCustomDialog(
        context: context,
        title: 'Sign up Error',
        content: result.errorMessage ?? 'invalid data try again',
        onTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> toInitial() async {
    emit(SignupInitial());
  }

  Future<void> toStep2() async {
    emit(SignupStep2());
  }

  Future<void> toStep3() async {
    emit(SignupStep3());
  }

  Future<void> toStep5() async {
    emit(SignupStep5());
  }

  Future<void> toChoosePhoto() async {
    emit(SignupChoosePhoto());
  }

  Future<void> savePhoto() async {
    if (imageData != null) {
      // eğer kullanıcı foto seçtiyse
      final result = await _repo.savePhoto(imageData); // seçilen fotoyu kaydet
      if (result) {
        debugPrint('photo saved.');
      } else {
        debugPrint('error while saving photo');
      }
    }
    // kullanıcı fotoğraf seçmediyse firestore'da photo: '' olacak
    // foto kullanılacağı zaman db den '' gelirse asset den default_photo kullanılır.
  }

  Future<void> toChooseUsername() async {
    emit(SignupChooseUsername(isUsernameValid: isUsernameValid));
  }

  Future<void> checkIsUsernameValid() async {
    isUsernameValid = await _repo.checkUsernameAvailability(getUsernameController.text);
    await Future.delayed(const Duration(seconds: 1));
    emit(SignupChooseUsername(isUsernameValid: isUsernameValid));
    debugPrint('text was ::::: ${getUsernameController.text}');
  }

  Future<void> saveUsername() async {
    final result = await _repo.saveUsername(getUsernameController.text); // seçilen fotoyu kaydet
    if (result) {
      debugPrint('username saved.');
    } else {
      debugPrint('error while saving username');
    }
  }

  Future<void> toChooseBio() async {
    emit(SignupChooseBio());
  }

  Future<void> saveBio() async {
    bool result = await _repo.saveBio(getBioController.text);
    if (result) {
      emit(SignupSuccess());
      debugPrint('bio saved. now you are returning to home page');
    } else {
      debugPrint(' Signup Cubit complete signup error');
    }
  }
}
