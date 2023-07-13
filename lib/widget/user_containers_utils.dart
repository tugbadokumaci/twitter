import 'package:flutter/material.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

class UserListViewContainer extends StatelessWidget {
  final Resource<List<UserModel>> resource;
  const UserListViewContainer({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    if (resource.status == Status.LOADING) {
      return LinearProgressIndicator();
    } else if (resource.status == Status.SUCCESS) {
      if (resource.data!.isNotEmpty) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resource.data!.length,
          itemBuilder: (context, index) {
            final user = resource.data![index];

            return Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ListTile(
                leading: CustomCircleAvatar(photoUrl: user.profilePhoto),
                title: Text(user.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(user.email, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: user.userId);
                },
              ),
            );
          },
        );
      }
    }
    return const Text('User Resource is not SUCCESS state');
  }
}
