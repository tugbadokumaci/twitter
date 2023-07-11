// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/bloc/signup_page/signup_cubit.dart';
import 'package:twitter/bloc/signup_page/signup_state.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/widget/text_fields_utils.dart';

import '../../utils/theme_utils.dart';
import '../../widget/box.dart';

class SignupView extends StatefulWidget {
  final SignupCubit viewModel;
  SignupView({super.key, required this.viewModel});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // File? _image;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(create: (_) => widget.viewModel, child: _buildScaffold(context));
  }

  Widget _buildScaffold(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pushNamed(context, '/home');
        }
      },
      builder: (context, state) {
        debugPrint('The state is $state');
        if (state is SignupInitial) {
          return _buildInitial(context);
        } else if (state is SignupStep2) {
          return _buildStep2(context);
        } else if (state is SignupStep3) {
          return _buildStep3(context);
        } else if (state is SignupStep5) {
          return _buildStep5(context);
        } else if (state is SignupChoosePhoto) {
          return _buildChoosePhoto(context);
        } else if (state is SignupChooseUsername) {
          return _buildChooseUsername(context, state as SignupChooseUsername);
        } else if (state is SignupChooseBio) {
          return _buildChooseBio(context);
        } else if (state is SignupLoading) {
          return _buildLoading();
        }
        // else if (state is SignupSuccess) {
        // return _buildSuccess();}
        else if (state is SignupError) {
          // return _buildError();
        }
        return Container();
      },
    );
  }

  Widget _buildInitial(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
            icon: const Icon(Icons.close, color: Colors.white)),
        title: const Text(
          'Adım 1/5',
        ),
        centerTitle: false,
      ),
      backgroundColor: CustomColors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hesabını oluştur",
              style:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            MyTextFieldWidget(
                validatorCallback: ((value) {
                  if (value!.isEmpty) {
                    return "name can't be null";
                  } else {}
                  return null;
                }),
                controller: widget.viewModel.getNameController,
                labelText: 'İsim'),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            MyTextFieldWidget(
                validatorCallback: ((value) {
                  if (value!.isEmpty) {
                    return "email can't be null";
                  } else {}
                  return null;
                }),
                controller: widget.viewModel.getEmailController,
                labelText: 'Email'),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            Text('Doğum Tarihi', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            const Text(
                'Bu, herkese açık olarak gösterilmeyecek. Bu hesap bir işletme, evcil hayvan veya başka bir şey için olsa bile kendi yaşını doğrulaman gerekir.'),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            MyTextFieldWidget(
                validatorCallback: ((value) {
                  if (value!.isEmpty) {
                    return "birthday can't be null";
                  } else {}
                  return null;
                }),
                controller: widget.viewModel.getBirthdayController,
                labelText: 'Doğum Tarihi'),
            const Spacer(),
            MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                buttonColor: Colors.white,
                content: Text('İleri',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                onPressed: () {
                  widget.viewModel.toStep2();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              widget.viewModel.toInitial();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text(
          'Adım 2/5',
        ),
        centerTitle: false,
      ),
      backgroundColor: CustomColors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deneyimini özelleştir",
              style:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Twitter içeriğini web'de nerede gördüğünü takip et",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                      Text(
                          "Twitter bu verileri deneyimini kişiselleştirmek için kullanır. Bu web gezintisi geçmişi hiçbir zaman adın, e-posta adresin veya telefon numaranla saklanmayacaktır.",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Checkbox(
                    value: true,
                    activeColor: CustomColors.blue,
                    onChanged: (bool? value) {},
                  ),
                ),
              ],
            ),
            const Box(size: BoxSize.LARGE, type: BoxType.VERTICAL),
            const Text(
              'Kaydolarak Koşullarımızı, Gizlilik Politikamızı ve Çerez Kullanımımızı kabul etmiş olursun. Twitter, e-posta adresin ve telefon numaran dahil olmak üzere iletişim bilgilerini Gizlilik Politikamızda belirtilen amaçlar doğrultusunda kullanabilir. Daha fazla bilgi al',
            ),
            const Spacer(),
            MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                buttonColor: Colors.white,
                content: Text('İleri',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                onPressed: () {
                  widget.viewModel.toStep3();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              widget.viewModel.toStep2();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text(
          'Adım 3/5',
        ),
        centerTitle: false,
      ),
      backgroundColor: CustomColors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
          MyTextFieldWidget(
            validatorCallback: ((value) {
              if (value!.isEmpty) {
                return "name can't be null";
              } else {}
              return null;
            }),
            controller: widget.viewModel.getNameController,
            labelText: 'İsim',
            isEnable: false,
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          MyTextFieldWidget(
            validatorCallback: ((value) {
              if (value!.isEmpty) {
                return "email can't be null";
              } else {}
              return null;
            }),
            controller: widget.viewModel.getEmailController,
            labelText: 'E-posta',
            isEnable: false,
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          MyTextFieldWidget(
            validatorCallback: ((value) {
              if (value!.isEmpty) {
                return "birthday can't be null";
              } else {}
              return null;
            }),
            controller: widget.viewModel.getBirthdayController,
            labelText: 'Doğum Tarihi',
            isEnable: false,
          ),
          const Spacer(),
          Text(
              'Kaydolarak, Hizmet Şartları, Gizlilik Politikası ve Çerez Kullanımı koşullarını kabul etmiş olursun. Twitter, hesabını güvende tutmak ve reklamlar dahil olmak üzere hizmetlerimizi kişiselleştirmek gibi, Gizlilik Politikamızda belirtilen amaçlar doğrultusunda e-posta adresini ve telefon numaranı da içeren iletişim bilgilerini kullanabilir. Daha fazla bilgi al. Buradan aksini belirtmediğin sürece e-postanı ve telefon numaranı girdiğinde diğerleri seni bulabilir.',
              style: Theme.of(context).textTheme.bodySmall),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              buttonColor: CustomColors.blue,
              content: Text('Kaydol',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
              onPressed: () {
                widget.viewModel.toStep5();
              })
        ]),
      ),
    );
  }

  Widget _buildStep5(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              widget.viewModel.toStep3();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text(
          'Adım 5/5',
        ),
        centerTitle: false,
      ),
      backgroundColor: CustomColors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Bir şifre girmen gerek",
            style:
                Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          Text(
            "6 veya daha fazla karakter olmasına dikkat et.",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
          const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
          MyTextFieldWidget(
            validatorCallback: ((value) {
              if (value!.isEmpty) {
                return "password can't be null";
              } else {}
              return null;
            }),
            controller: widget.viewModel.getPasswordController,
            labelText: 'Password',
            isSecure: true,
          ),
          const Spacer(),
          MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              buttonColor: Colors.white,
              content: Text(
                'İleri',
                style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                widget.viewModel.signUp(context);
              })
        ]),
      ),
    );
  }

  Widget _buildChoosePhoto(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              icon: const Icon(Icons.close, color: Colors.white)),
          title: const FaIcon(FontAwesomeIcons.twitter, size: 35, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Profil fotoğrafı seçin",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                Text(
                  "Favori selfie'niz mi var? Hemen yükleyin.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
                const Box(size: BoxSize.LARGE, type: BoxType.VERTICAL),
                imageProfile(context),
                const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
                TextButton(
                    onPressed: () {
                      widget.viewModel.toChooseUsername();
                    },
                    child: Text('Şimdilik geçin',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: CustomColors.blue, fontWeight: FontWeight.bold))),
                const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
                Container(
                    child: (widget.viewModel.imageData == null)
                        ? SizedBox()
                        : MyButtonWidget(
                            context: context,
                            height: 50,
                            width: 350,
                            buttonColor: Colors.white,
                            content: Text(
                              'Kaydet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              widget.viewModel.savePhoto();
                              widget.viewModel.toChooseUsername();
                            })),
              ],
            ),
          ),
        ));
  }

  // void takePhoto(ImageSource source) async {
  //   final _picker = ImagePicker();
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     final File file = File(pickedFile.path);
  //     final Uint8List imageData = await file.readAsBytes();
  //     widget.viewModel.imageData = imageData;
  //     widget.viewModel.toChoosePhoto();
  //   }
  // }

  void takePhoto(ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // _image = File(pickedFile.path);
        // List<int> imageBytes = _image!.readAsBytesSync();
        // widget.viewModel.image = imageBytes;
        final File file = File(pickedFile.path);
        final Uint8List imageData = file.readAsBytesSync();
        widget.viewModel.imageData = imageData;
        widget.viewModel.toChoosePhoto();
      });
    }
  }

  Widget imageProfile(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 140,
      child: Stack(
        children: [
          myCircleAvatar(),
          Positioned(
              bottom: 55.0,
              right: 55.0,
              child: InkWell(
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                  },
                  child: const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white)))
        ],
      ),
    );
  }

  CircleAvatar myCircleAvatar() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: (widget.viewModel.imageData != null)
          ? MemoryImage(widget.viewModel.imageData!)
          : const AssetImage('assets/images/default_image.png') as ImageProvider,
    );
  }

  Widget _buildChooseUsername(BuildContext context, SignupChooseUsername state) {
    debugPrint(state.isUsernameValid.toString());
    return Scaffold(
      appBar: AppBar(title: const FaIcon(FontAwesomeIcons.twitter, size: 35, color: Colors.white)),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text('Kullanıcı adınızı seçin',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            Text('Merak etmeyin bunu daha sonra değiştirebilirsiniz.', style: Theme.of(context).textTheme.titleMedium),
            const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
            MyTextFieldWidget(
              validatorCallback: ((value) {
                if (value!.isEmpty) {
                  return "Username can't be null";
                } else {}
                return null;
              }),
              controller: widget.viewModel.getUsernameController,
              labelText: 'Kullanıcı adı',
              onChanged: (p0) {
                setState(() {
                  widget.viewModel.checkIsUsernameValid();
                });
              },
            ),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            Container(
              child: (widget.viewModel.getUsernameController.text == '')
                  ? const SizedBox()
                  : Container(
                      child: (widget.viewModel.getUsernameController.text == '')
                          ? const SizedBox()
                          : Container(
                              child: (state.isUsernameValid ? usernameSuccessContainer() : usernameErrorContainer()),
                            ),
                    ),
            ),
            const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
            MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              enabled: widget.viewModel.isUsernameValid,
              buttonColor: Colors.white,
              content: Text('İleri', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)),
              onPressed: () {
                widget.viewModel.saveUsername();
                widget.viewModel.toChooseBio();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget usernameSuccessContainer() {
    return const Row(
      children: [
        Icon(Icons.check, color: Colors.green),
        Box(size: BoxSize.SMALL, type: BoxType.HORIZONTAL),
        Text('This username is avaliable', style: TextStyle(color: Colors.green))
      ],
    );
  }

  Widget usernameErrorContainer() {
    return const Row(
      children: [
        Icon(Icons.error_outline_outlined, color: Colors.red),
        Box(size: BoxSize.SMALL, type: BoxType.HORIZONTAL),
        Text('This username is taken', style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget _buildChooseBio(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              icon: const Icon(Icons.close, color: Colors.white)),
          title: const FaIcon(FontAwesomeIcons.twitter, size: 35, color: Colors.white)),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text('Kendinizden bahsedin',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            Text('Sizi özel yapan nedir? Üzerinde çok düşünmeyin, eğlenin.',
                style: Theme.of(context).textTheme.titleMedium),
            const Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
            MyTextFieldWidget(
                validatorCallback: ((value) {
                  if (value!.isEmpty) {
                    return "Bio can't be null";
                  } else {}
                  return null;
                }),
                controller: widget.viewModel.getBioController,
                labelText: 'Bio'),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Şimdilik geçin',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: CustomColors.blue, fontWeight: FontWeight.bold))),
            const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
            MyButtonWidget(
                context: context,
                height: 50,
                width: 350,
                buttonColor: Colors.white,
                content: Text('İleri', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)),
                onPressed: () {
                  widget.viewModel.saveBio();
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
        child: CircularProgressIndicator(
      color: CustomColors.blue,
      backgroundColor: CustomColors.lightGray,
    ));
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text('Hesabıını oluştur', style: Theme.of(context).textTheme.headlineMedium),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          nameField(),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          emailField(),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          birthdayField(),
          const Spacer(),
          MyButtonWidget(
              context: context,
              height: 50,
              width: 350,
              buttonColor: Colors.white,
              content: const Text('Next'),
              onPressed: () {})
        ],
      ),
    );
  }

  Widget nameField() {
    return MyTextFieldWidget(
        validatorCallback: ((value) {
          if (value!.isEmpty) {
            return "name can't be null";
          } else {}
          return null;
        }),
        controller: widget.viewModel.getNameController,
        labelText: 'name',
        maxLength: 50);
  }

  Widget emailField() {
    return MyTextFieldWidget(
        validatorCallback: ((value) {
          if (value!.isEmpty) {
            return "email can't be null";
          } else {}
          return null;
        }),
        controller: widget.viewModel.getEmailController,
        labelText: 'email');
  }

  Widget birthdayField() {
    return MyTextFieldWidget(
        validatorCallback: ((value) {
          if (value!.isEmpty) {
            return "birthday can't be null";
          } else {}
          return null;
        }),
        controller: widget.viewModel.getBirthdayController,
        labelText: 'email');
  }
}
