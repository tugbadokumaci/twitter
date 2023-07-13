import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  const CustomCircleAvatar({Key? key, required this.photoUrl, this.radius = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: photoUrl != ''
          ? NetworkImage(photoUrl!)
          : const AssetImage('assets/images/default_image.png') as ImageProvider,
    );
  }
}
