import 'package:flutter/material.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

class UserListViewContainer extends StatelessWidget {
  final Resource<List<UserModel>> resource;
  const UserListViewContainer({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.isNotEmpty) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resource.data!.length,
          itemBuilder: (context, index) {
            final user = resource.data![index];
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: ListTile(
                leading: CustomCircleAvatar(photoUrl: user.profilePhoto),
                title: Text(user.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text('@${user.username}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray)),
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: user.userId);
                },
              ),
            );

            // return Padding(
            //   padding: const EdgeInsets.only(top: 2.0),
            //   child: ListTile(
            //     leading: CustomCircleAvatar(photoUrl: user.profilePhoto),
            //     title: Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            //     subtitle: Text('@${user.username}',
            //         style: TextStyle(color: CustomColors.lightGray, fontWeight: FontWeight.bold)),
            //     onTap: () {
            //       Navigator.pushNamed(context, '/profile', arguments: user.userId);
            //     },
            //   ),
            // );
          },
        );
      } else {
        return const Text('No user found');
      }
    }
    debugPrint('Users Containers retured ERROR STATE');
    return Container();
  }
}
