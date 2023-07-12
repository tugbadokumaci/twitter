import 'package:flutter/material.dart';
import 'package:twitter/bloc/home_page/home_cubit.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';
import 'package:twitter/bloc/home_page/home_view.dart';
import 'package:twitter/bloc/search_page/search_cubit.dart';
import 'package:twitter/bloc/search_page/search_repository.dart';
import 'package:twitter/bloc/search_page/search_view.dart';
import 'package:twitter/service_locator.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        // Perform actions based on the tapped item
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeView(
                  viewModel: HomeCubit(repo: locator<HomeRepository>()),
                ),
              ),
            );
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchView(
                  viewModel: SearchCubit(repo: locator<SearchRepository>()),
                ),
              ),
            );

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchView(
                  viewModel: SearchCubit(repo: locator<SearchRepository>()),
                ),
              ),
            );
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchView(
                  viewModel: SearchCubit(repo: locator<SearchRepository>()),
                ),
              ),
            );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Message',
        ),
      ],
    );
  }
}
