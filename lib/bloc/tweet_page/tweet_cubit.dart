// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:twitter/bloc/tweet_page/tweet_repository.dart';
import 'package:twitter/bloc/tweet_page/tweet_state.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';

class TweetCubit extends Cubit<TweetState> {
  final TweetRepository _repo;
  final TextEditingController getTextController = TextEditingController();
  Uint8List? imageData;

  TweetCubit({
    required TweetRepository repo,
  })  : _repo = repo,
        super(TweetInitial());

  Future<void> sendTweet(BuildContext context) async {
    emit(TweetLoading());
    final result = await _repo.sendTweet(Constants.USER.userId, getTextController.text, imageData);
    emit(TweetInitial());
    if (result == true) {
      Fluttertoast.showToast(
        msg: 'Tweet sent successfully',
        backgroundColor: Colors.green,
        gravity: ToastGravity.TOP,
      );
      emit(TweetSuccess());
      debugPrint('tweet send succesfully');
    } else {
      debugPrint('error occured while sending the tweet');
    }
  }
}
