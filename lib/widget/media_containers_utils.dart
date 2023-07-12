import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import '../utils/resource.dart';
import '../utils/theme_utils.dart';

Widget mediaListViewContainer(Resource<List<Uint8List>> resource) {
  return ListView.builder(
    // scrollDirection: Axis.vertical,
    // shrinkWrap: true,
    // physics: const NeverScrollableScrollPhysics(),
    itemCount: resource.data!.length,
    itemBuilder: (context, index) {
      Uint8List image = resource.data![index];

      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListTile(
          leading: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 25),
          title: Row(
            children: [
              Text(Constants.USER.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text(
                '@${Constants.USER.username}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(height: 200, width: 300, child: Image.memory(image)),
          ),
          // trailing: Text(Constants.USER.name),
        ),
      );
    },
  );
}
