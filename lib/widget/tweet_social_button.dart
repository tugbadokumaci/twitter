import 'package:flutter/material.dart';
import 'package:twitter/utils/constants.dart';

class TweetSocialButton extends StatefulWidget {
  final Function() callback;
  int count;
  TweetSocialButton({super.key, required this.callback, required this.count});

  @override
  State<TweetSocialButton> createState() => _TweetSocialButtonState();
}

class _TweetSocialButtonState extends State<TweetSocialButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return TextButton(
    //     onPressed: () {
    //       widget.callback();
    //       setState(() {
    //         widget.count++;
    //       });
    //       // baseViewModel.updateFavList(tweet.id);
    //     },
    //     child: Row(
    //       children: [
    //         Constants.USER.favList.contains(tweet.id)
    //             ? const Icon(Icons.favorite, color: Colors.red)
    //             : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray),
    //         const SizedBox(width: 8),
    //         Text(
    //           widget.count.toString(),
    //           style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
    //         )
    //       ],
    //     ));
  }
}
