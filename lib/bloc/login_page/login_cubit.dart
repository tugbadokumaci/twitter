// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter/bloc/login_page/login_repository.dart';

import '../../models/user_model.dart';
import '../../shared_preferences_service.dart';
import '../../utils/constants.dart';
import '../../utils/resource.dart';
import '../../utils/utils.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repo;

  LoginCubit({
    required LoginRepository repo,
  })  : _repo = repo,
        super(LoginInitial());

  TextEditingController getEmailController = TextEditingController();
  TextEditingController getPasswordController = TextEditingController();

  Future<void> initialize() async {
    getEmailController.text = await SharedPreferencesService.getEmailPreference();
    getPasswordController.text = await SharedPreferencesService.getPasswordPreference();
    await Future.delayed(const Duration(seconds: 2));
    emit(LoginForm());
  }

  Future<void> toStep2() async {
    if (getEmailController.text == '') {
      Fluttertoast.showToast(
        msg: 'email field cant be null',
        backgroundColor: Colors.redAccent,
        gravity: ToastGravity.TOP,
      );
      emit(LoginInitial());
    } else {
      emit(LoginStep2());
    }
  }

  Future<void> login(BuildContext context) async {
    if (getPasswordController.text == '') {
      Fluttertoast.showToast(
        msg: 'password field  cant be null',
        backgroundColor: Colors.redAccent,
        gravity: ToastGravity.TOP,
      );
      emit(LoginStep2());
    } else {
      debugPrint('Login Clicked');
      emit(LoginLoading());
      final email = getEmailController.text;
      final password = getPasswordController.text;

      Resource<UserModel> resource = await _repo.logIn(email, password);

      if (resource.status == Status.SUCCESS) {
        Constants.USER = resource.data!;
        await SharedPreferencesService.setStringPreference(email, password);
        emit(LoginSuccess());
        Fluttertoast.showToast(
          msg: 'Log in Success',
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP,
        );
        Navigator.pushNamed(context, homeRoute);
      } else {
        emit(LoginForm());
        Utils.showCustomDialog(
          context: context,
          title: 'Log in Error',
          content: resource.errorMessage ?? '',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/logIn');
          },
        );
      }
    }
  }
}
