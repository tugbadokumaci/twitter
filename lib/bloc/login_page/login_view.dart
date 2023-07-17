// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/inheritance/app_style.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/widget/text_fields_utils.dart';

import '../../utils/theme_utils.dart';
import '../../widget/box.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginView extends StatelessWidget {
  final LoginCubit viewModel;
  LoginView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(create: (_) => viewModel, child: _buildScaffold(context));
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/welcome');
              },
              icon: const Icon(Icons.close)),
        ),
        backgroundColor: Colors.black,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushNamed(context, '/home');
            }
          },
          builder: ((context, state) {
            if (state is LoginInitial) {
              return _buildInitial(context);
            } else if (state is LoginStep2) {
              return _buildStep2(context);
            }
            // else if(state is Login)
            return Container();
          }),
        ));
  }

  Widget _buildInitial(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Twitter'a giriş yap",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
            const Box(
              size: BoxSize.MEDIUM,
              type: BoxType.VERTICAL,
            ),

            /// SOCİALS CONTAINER
            MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 30, width: 30, child: Image.asset('assets/images/google_logo_small.png')),
                  Box(size: BoxSize.SMALL, type: BoxType.HORIZONTAL),
                  Text('Google ile devam edin', style: CustomTextStyles.buttonTextStyle(context, Colors.black)),
                ],
              ),
              buttonColor: Colors.white,
              onPressed: () {},
            ),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 30, width: 30, child: Image.asset('assets/images/apple_logo_small.png')),
                  Box(size: BoxSize.SMALL, type: BoxType.HORIZONTAL),
                  Text('Apple ile devam edin', style: CustomTextStyles.buttonTextStyle(context, Colors.black)),
                ],
              ),
              onPressed: () {},
              buttonColor: Colors.white,
            ),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: const Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              const Text("veya"),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: const Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              ////
              ///
            ]),
            MyTextFieldWidget(
                validatorCallback: ((value) {
                  if (value!.isEmpty) {
                    return "email can't be null";
                  } else {}
                  return null;
                }),
                controller: viewModel.getEmailController,
                labelText: 'Email'),
            const Box(
              size: BoxSize.SMALL,
              type: BoxType.VERTICAL,
            ),
            MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                buttonColor: Colors.white,
                content: Text('İleri',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                onPressed: () {
                  viewModel.toStep2();
                }),

            const Box(
              size: BoxSize.SMALL,
              type: BoxType.VERTICAL,
            ),
            MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              buttonColor: Colors.black,
              content: const Text('Forgot Password?'),
              onPressed: () {},
              borderColor: Colors.white,
            ),
            const Box(
              size: BoxSize.MEDIUM,
              type: BoxType.VERTICAL,
            ),
            Row(
              children: [
                Text('Henüz bir hesabın yok mu?',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray)),
                TextButton(
                  child: Text('Kaydol',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.blue)),
                  onPressed: () => Navigator.pushNamed(context, '/signUp'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children: [
          Text(
            "Şifrenizi girin",
            style:
                Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          MyTextFieldWidget(
            validatorCallback: ((value) {
              if (value!.isEmpty) {
                return "email can't be null";
              } else {}
              return null;
            }),
            controller: viewModel.getEmailController,
            labelText: 'Email',
            isEnable: false,
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          MyTextFieldWidget(
              validatorCallback: ((value) {
                if (value!.isEmpty) {
                  return "password can't be null";
                } else {}
                return null;
              }),
              controller: viewModel.getPasswordController,
              labelText: 'Şifre',
              isSecure: true),
          Spacer(),
          MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              buttonColor: Colors.white,
              content: Text('Log in',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                viewModel.login(context);
              })
        ],
      ),
    );
  }
}
