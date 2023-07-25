import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/box.dart';

import '../../inheritance/app_style.dart';
import '../../utils/button_utils.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              const FaIcon(FontAwesomeIcons.twitter, size: 35, color: Colors.white),
              const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
              Text(
                'Şu anda olup bitenler ',
                style:
                    Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white, fontFamily: 'ChirpHeavy'),
              ),
              const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
              Text(
                "Twitter'a bugün katıl. ",
                style:
                    Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontFamily: 'ChirpHeavy'),
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                      child: Divider(
                        color: CustomColors.lightGray,
                        height: 50,
                      ),
                    ),
                  ),
                  const Text("veya"),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                      child: Divider(
                        color: CustomColors.lightGray,
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
              MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                content: Text('Hesap oluştur',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                buttonColor: CustomColors.blue,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'By signing up, you agree to the Terms of Service and Privacy Policy, including Cookie Use.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const Box(size: BoxSize.LARGE, type: BoxType.VERTICAL),
              Text(
                'Zaten bir hesabın var mı?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                content: Text('Giriş yap',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: CustomColors.blue, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushNamed(context, '/logIn');
                },
                buttonColor: Colors.transparent,
                borderColor: Colors.white,
              ),
              // const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
              Image.asset(
                'assets/images/welcome_page.jpeg',
                // fit: BoxFit.fitWidth,
                height: 500,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
