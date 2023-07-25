// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../models/user_model.dart';
import '../utils/button_utils.dart';
import '../utils/constants.dart';
import '../utils/theme_utils.dart';

class OpenBottomSheet extends StatefulWidget {
  OpenBottomSheet({
    super.key,
    required this.tweet,
    required this.baseViewModel,
    required this.incrementCommentCountByOne,
    required this.user,
  });
  TweetModel tweet;
  BaseViewModel baseViewModel;
  final Function() incrementCommentCountByOne;
  final UserModel user;

  @override
  State<OpenBottomSheet> createState() => _OpenBottomSheetState();
}

class _OpenBottomSheetState extends State<OpenBottomSheet> {
  @override
  Widget build(BuildContext context) {
    debugPrint('see');
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Expanded(
                // Wrap the action in an Expanded widget
                child: Center(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MyButtonWidget(
                      context: context,
                      height: 30,
                      width: 60,
                      buttonColor: CustomColors.blue,
                      content:
                          Text('Yanıtla', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.baseViewModel.sendTweet(context, widget.tweet);
                        widget.baseViewModel.getTweetController.text = ''; // drop text setState?????!!!
                        widget.baseViewModel.imageData = null; // drop image setState?????!!!
                        widget.incrementCommentCountByOne();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.black,
          body: Column(
            children: [
              bottomSheetTweetListTile(widget.tweet, widget.baseViewModel),
              SizedBox(height: 5),
              bottomSheetTextFormField(widget.tweet, widget.baseViewModel, context),
              bottomSheetMediaContainer(widget.tweet, widget.baseViewModel),
            ],
          )),
    );
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     useSafeArea: true,
    //     context: widget.context,
    //     builder: (BuildContext context) {
    //       debugPrint('show bottom model buildings');
    //       return Container(
    //         height: MediaQuery.of(context).size.height,
    //         child: Scaffold(
    //             appBar: AppBar(
    //               leading: IconButton(
    //                 icon: const Icon(Icons.arrow_back, color: Colors.white),
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //               ),
    //               actions: [
    //                 Expanded(
    //                   // Wrap the action in an Expanded widget
    //                   child: Center(
    //                     child: Align(
    //                       alignment: Alignment.centerRight,
    //                       child: MyButtonWidget(
    //                         context: context,
    //                         height: 30,
    //                         width: 60,
    //                         buttonColor: CustomColors.blue,
    //                         content: Text('Yanıtla',
    //                             style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)),
    //                         onPressed: () {
    //                           widget.baseViewModel.sendTweet(context, widget.tweet);
    //                           widget.baseViewModel.getTweetController.text = ''; // drop text setState?????!!!
    //                           widget.baseViewModel.imageData = null; // drop image setState?????!!!
    //                           widget.incrementCommentCountByOne();
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //             backgroundColor: Colors.black,
    //             body: Column(
    //               children: [
    //                 bottomSheetTweetListTile(widget.tweet, widget.baseViewModel),
    //                 SizedBox(height: 5),
    //                 bottomSheetTextFormField(widget.tweet, widget.baseViewModel, context),
    //                 bottomSheetMediaContainer(widget.tweet, widget.baseViewModel),
    //               ],
    //             )),
    //       );
    //     });
  }

  Widget bottomSheetMediaContainer(TweetModel tweet, BaseViewModel baseViewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: baseViewModel.imageData != null ? ImageContainer(baseViewModel) : const SizedBox(),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery, baseViewModel);
                },
                icon: Icon(Icons.photo_outlined, color: CustomColors.blue)),
            IconButton(onPressed: () {}, icon: Icon(Icons.gif_box_outlined, color: CustomColors.blue)),
            IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions_outlined, color: CustomColors.blue)),
            IconButton(onPressed: () {}, icon: Icon(Icons.pin_drop_outlined, color: CustomColors.blue)),
          ],
        )
      ],
    );
  }

  Widget bottomSheetTextFormField(TweetModel tweet, BaseViewModel baseViewModel, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: CustomCircleAvatar(
            photoUrl: Constants.USER.profilePhoto,
            radius: 25,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          // wrap textformfield with expanded
          child: TextFormField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return "tweet can't be null";
              } else {}
              return null;
            }),
            onFieldSubmitted: (String tweet) {
              debugPrint(tweet);
            },
            controller: baseViewModel.getTweetController,
            maxLines: 3,
            maxLength: 280,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Başka bir Tweet ekle.',
              counterStyle: TextStyle(color: Colors.white),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheetTweetListTile(TweetModel tweet, BaseViewModel baseViewModel) {
    return Row(
      children: [
        Column(
          children: [
            CustomCircleAvatar(
              photoUrl: Constants.USER.profilePhoto,
              radius: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                height: 100, // make the height change with the tweet height
                child: VerticalDivider(
                  color: CustomColors.darkGray,
                  thickness: 2.0,
                  width: 20,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.user.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '@${widget.user.username}',
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(DateFormat('dd.MM.yyyy').format(widget.tweet.date),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(widget.tweet.text),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget ImageContainer(BaseViewModel baseViewModel) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
              alignment: Alignment.center,
              height: 200,
              child: Image.memory(baseViewModel.imageData!, fit: BoxFit.fitHeight)),
          Positioned(
            top: 10.0, // Yatayda aşağı doğru 8.0 birim kaydırma
            right: 10.0, // Dikeyde sola doğru 8.0 birim kaydırma
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black54,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    baseViewModel.imageData = null;
                  });
                },
                iconSize: 20,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source, BaseViewModel baseViewModel) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        final File file = File(pickedFile.path);
        final Uint8List imageData = file.readAsBytesSync();
        baseViewModel.imageData = imageData;
      });
    }
  }
}
