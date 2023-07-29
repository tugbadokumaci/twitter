// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/bloc/tweet_page/tweet_cubit.dart';
import 'package:twitter/bloc/tweet_page/tweet_state.dart';
import 'package:twitter/inheritance/app_style.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../../utils/constants.dart';
import '../../utils/theme_utils.dart';

class TweetView extends StatefulWidget {
  final TweetCubit viewModel;
  TweetView({super.key, required this.viewModel});

  @override
  State<TweetView> createState() => _TweetViewState();
}

class _TweetViewState extends State<TweetView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TweetCubit>(
      create: (_) => widget.viewModel,
      child: _buildScaffold(context),
    );
  }

  SafeArea _buildScaffold(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: TextButton(
              onPressed: () {
                widget.viewModel.sendTweet(context);
              },
              child: Text('Tweetle', style: CustomTextStyles.buttonTextStyle(context, CustomColors.blue)),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: BlocConsumer<TweetCubit, TweetState>(
          listener: (context, state) {
            if (state is TweetSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            debugPrint('Tweet view state: $state');
            if (state is TweetInitial) {
              return _buildInitial();
            } else if (state is TweetLoading) {
              return _buildLoading();
            }
            // } else if (state is TweetSuccess) {
            //   _buildSuccess();
            // }
            // }else if( state is TweetError){
            // }
            return Container();
          },
        ),
      ),
    ));
  }

  Widget _buildInitial() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatar(
                  photoUrl: Constants.USER.profilePhoto,
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: widget.viewModel.getTextController,
                    maxLines: 5,
                    maxLength: 280, // Set the maximum character limit
                    decoration: const InputDecoration(hintText: 'What\'s happening?' // Provide a hint text
                        ),
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.photo, color: CustomColors.blue)),
            Container(
              height: 400,
              width: 400,
              child: (widget.viewModel.imageData != null ? Image.memory(widget.viewModel.imageData!) : SizedBox()),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    widget.viewModel.imageData = null;
                  });
                },
                child: (widget.viewModel.imageData != null) ? Text('Remove photo') : SizedBox())
          ],
        ),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        final File file = File(pickedFile.path);
        final Uint8List imageData = file.readAsBytesSync();
        widget.viewModel.imageData = imageData;
      });
    }
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircularProgressIndicator(
          color: CustomColors.blue,
          backgroundColor: CustomColors.lightGray,
        ),
      ],
    );
  }
}
