// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/signup_page/signup_state.dart';
import 'package:twitter/bloc/signup_page/signup_repository.dart';
import '../../utils/resource.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  // Resource<String> signupResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<String> birthdayResource = Resource(status: Status.LOADING, data: null, errorMessage: null);

  late Resource<String> signupResource;
  late Resource<String> birthdayResource;

  Future<void> signUp(BuildContext context) async {
    signupResource = await _repo.signUp(
        getEmailController.text, getPasswordController.text, getNameController.text, birthdayResource.data!);
    if (signupResource.status == Status.SUCCESS) {
// toast sign up success
      emit(SignupChoosePhoto());
    } else {
// toast sign up error
    }
  }

  Future<void> toInitial() async {
    emit(SignupInitial());
  }

  Future<void> toStep2() async {
    birthdayResource = await _repo.checkBirthdayAvaliability(getBirthdayController.text);
    if (getNameController.text == '') {
      // name field cant be null
      Fluttertoast.showToast(
        msg: 'name field cant be null',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      emit(SignupInitial());
    } else {
      if (getEmailController.text == '') {
        // email field cant be null
        Fluttertoast.showToast(
          msg: 'email field cant be null',
          backgroundColor: Colors.redAccent,
          gravity: ToastGravity.TOP,
        );

        emit(SignupInitial());
      } else {
        if (getBirthdayController.text == '') {
          // birthday field cant be null
          Fluttertoast.showToast(
            msg: ' birthday field cant be null',
            backgroundColor: Colors.redAccent,
            gravity: ToastGravity.TOP,
          );

          emit(SignupInitial());
        } else if (birthdayResource.status == Status.ERROR) {
          // birthday field is incorrect
          Fluttertoast.showToast(
            msg: 'birthday field is incorrect',
            backgroundColor: Colors.redAccent,
            gravity: ToastGravity.TOP,
          );

          emit(SignupInitial());
        } else {
          // sign up success
          // Fluttertoast.showToast(
          //   msg: ' sign up success',
          //   backgroundColor: Colors.greenAccent,
          //   gravity: ToastGravity.TOP,
          // );

          emit(SignupStep2());
        }
      }
    }
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
