import 'package:flutter/material.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navbarWidth = MediaQuery.of(context).size.width * 0.8;
    final name = Constants.USER.name;
    final username = Constants.USER.username;

    return Container(
      width: navbarWidth,
      color: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 220, // For settting drawer height
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Hesap bilgileri',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      // CircleAvatar(radius: 25, backgroundImage: null),
                      CustomCircleAvatar(
                        photoUrl: Constants.USER.profilePhoto,
                        radius: 25,
                      ),
                      const Spacer(),
                      const Icon(Icons.add, color: Colors.white)
                    ],
                  ),
                  const Box(size: BoxSize.EXTRASMALL, type: BoxType.VERTICAL),
                  Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('@$username', style: Theme.of(context).textTheme.titleMedium),
                  const Box(size: BoxSize.EXTRASMALL, type: BoxType.VERTICAL),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${Constants.USER.following.length} Takip Edilen',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: 10),
                      Text('${Constants.USER.followers.length} Takipçi',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Profil', style: Theme.of(context).textTheme.titleMedium),
            leading: const Icon(Icons.person_outlined, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile', arguments: Constants.USER.userId);
            },
          ),
          ListTile(
            title: Text('Twitter Blue', style: Theme.of(context).textTheme.titleMedium),
            leading: const Icon(Icons.book, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Listeler', style: Theme.of(context).textTheme.titleMedium),
            leading: const Icon(Icons.list_alt_outlined, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Yer işaretleri', style: Theme.of(context).textTheme.titleMedium),
            leading: const Icon(Icons.bookmark_outline, color: Colors.white),
            onTap: () {
              // Navigator.pushNamed(context, )
              Navigator.pop(context);
            },
          ),
          Divider(color: CustomColors.lightGray),
          const ExpansionTile(
            title: Text(
              'İçerik Üreticisi Stüdyosu',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'İstatistikler',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
          const ExpansionTile(
            title: Text(
              'Profesyonel Araçlar',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'İstatistikler',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
          const ExpansionTile(
            title: Text(
              'Ayarlar ve destek',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'İstatistikler',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// enum Pages {
//   home,
//   search,
//   notifications,
//   message,
// }
