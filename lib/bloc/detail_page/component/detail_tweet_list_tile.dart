import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter/bloc/detail_page/component/detail_tweet_social_button.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import 'package:twitter/widget/tweet_open_bottom_sheet.dart';

import '../../../models/tweet_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme_utils.dart';
import '../detail_cubit.dart';

class DetailTweetListTile extends StatefulWidget {
  DetailTweetListTile({
    super.key,
    required this.user,
    required this.viewModel,
    required this.tweet,
    this.fav = false, // !!!
  });

  final UserModel user;
  final DetailCubit viewModel;
  final TweetModel tweet;
  bool fav;

  @override
  State<DetailTweetListTile> createState() => _DetailTweetListTileState();
}

class _DetailTweetListTileState extends State<DetailTweetListTile> {
  @override
  Widget build(BuildContext context) {
    // bool fav = Constants.USER.favList.contains(widget.tweet.id);
    int favCount = widget.tweet.favList.length;

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CustomCircleAvatar(photoUrl: widget.user.profilePhoto, radius: 25),
            title: Text(
              widget.user.name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Flexible(
              child: Container(
                child: Text(
                  '@${widget.user.username}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.tweet.text, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Container(
                    alignment: Alignment.center,
                    child: widget.tweet.imageData != null
                        ? SizedBox(
                            height: 260,
                            width: MediaQuery.of(context).size.width,
                            child: Image.memory(widget.tweet.imageData!, fit: BoxFit.fitWidth),
                          )
                        : const SizedBox()),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: DateFormat("h:mm a · dd MMM y", "tr_TR").format(widget.tweet.date),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' · ',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                      ),
                      TextSpan(
                        text: '37.9 B ',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Görüntülenme',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                      ),
                    ],
                  ),
                ),
                // Text(
                //   DateFormat("h:mm a · dd MMM y", "tr_TR").format(widget.tweet.date),
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: CustomColors.lightGray),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text.rich(
                TextSpan(
                  text: '17',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Retweet',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: '2',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Alıntılar',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: favCount.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Beğeni',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: '1',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Yer işaretleri',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: CustomColors.lightGray),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 25),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: '@${widget.user.name}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.blue),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' adlı kullanıcılara yanıt olarak',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
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
                      controller: widget.viewModel.getTweetController,
                      maxLines: 3,
                      maxLength: 280,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Yanıtını tweetle.',
                        counterStyle: TextStyle(color: Colors.white),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Container(
                      child: widget.viewModel.imageData != null ? ImageContainer(widget.viewModel) : const SizedBox(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              takePhoto(ImageSource.gallery);
                            },
                            icon: Icon(Icons.photo, color: CustomColors.blue)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.gif_box_rounded, color: CustomColors.blue)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions, color: CustomColors.blue)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.pin_drop, color: CustomColors.blue)),
                        const Spacer(),
                        MyButtonWidget(
                            context: context,
                            height: 30,
                            width: 80,
                            buttonColor: CustomColors.blue,
                            content: Text('Yanıtla',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                            onPressed: () {
                              widget.viewModel.sendTweet(context, widget.tweet);
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(color: CustomColors.lightGray),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    openBottomSheet(context, widget.tweet, widget.viewModel);
                  },
                  child: Icon(Icons.mode_comment_outlined, size: 20, color: CustomColors.lightGray)),
              TextButton(onPressed: () {}, child: FaIcon(Icons.share, size: 20, color: CustomColors.lightGray)),
              DetailTweetSocialButton(
                callback: (bool fav, int count) {
                  widget.viewModel.updateFavList(widget.tweet.id);

                  setState(() {
                    widget.fav = fav;
                    widget.tweet.favList.length = count;
                    // favCount = count;
                  });

                  // setState(() {
                  //   favCount = widget.tweet.favList.length;
                  // });
                },
                count: widget.tweet.favList.length,
                tweet: widget.tweet,
                fav: widget.fav,
              ),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
            ],
          )
        ],
      ),
    );
  }

  Widget ImageContainer(DetailCubit viewModel) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.center, height: 200, width: 200, child: Image.memory(widget.viewModel.imageData!)),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  viewModel.imageData = null;
                });
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 30)),
        ),
      ],
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
}
