// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_cubit.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../../utils/box_constants.dart';
import '../../utils/theme_utils.dart';
import '../../widget/box.dart';

class ProfileView extends StatelessWidget {
  final ProfileCubit viewModel;
  ProfileView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => viewModel,
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.USER.name,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tweet');
        },
        backgroundColor: CustomColors.blue,
        child: Container(
          width: 45, // Set the desired width
          height: 45, // Set the desired height
          child: Image.asset('assets/images/new_tweet.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileInitial) {}
          },
          builder: (context, state) {
            debugPrint('Profile view state: $state');
            if (state is ProfileInitial) {
              return _buildInitial(context);
            }
            //  else if (state is ProfileLoading) {
            //   _buildLoading();
            // } else if (state is HomeSuccess) {
            //   _buildSuccess();
            // }
            // }else if( state is HomeError){
            // }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _profileHeader(context),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Constants.USER.name, style: Theme.of(context).textTheme.headlineSmall),
              Text(
                '@${Constants.USER.username}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray),
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Text((Constants.USER.bio == '' ? 'Biyografi bilgisi bulunmamaktadır.' : Constants.USER.bio)),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Padding(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [
                    Icon(Icons.pin_drop, size: 20),
                    Text((Constants.USER.location == '' ? 'Konum bilgisi bulunmamaktadır.' : 'Konum, Konum'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [const Icon(Icons.cake, size: 20), Text(Constants.USER.birthday)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [const Icon(Icons.calendar_month, size: 20), Text(Constants.USER.accountCreationDate)],
                ),
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Row(
                children: [
                  Text('${Constants.USER.following.length} Takip edilen'),
                  const Box(size: BoxSize.MEDIUM, type: BoxType.HORIZONTAL),
                  Text('${Constants.USER.followers.length} Takipçi'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
          child: DefaultTabController(
            length: 5, // Number of tabs
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  indicatorColor: CustomColors.blue,
                  tabs: const [
                    Tab(text: 'Tweetler'),
                    Tab(text: 'Yanıtlar'),
                    Tab(text: 'Öne Çıkanlar'),
                    Tab(text: 'Medya'),
                    Tab(text: 'Beğeni'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      tweetContainer(),
                      yanitlarContainer(),
                      oneCikanlarContainer(),
                      medyaContainer(),
                      begeniContainer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  SizedBox _profileHeader(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 170, width: MediaQuery.of(context).size.width, color: Colors.black),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/default_background.webp', fit: BoxFit.fitWidth)),
          ),
          Positioned(
              bottom: 0.0, right: 300.0, child: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 40)),
          Align(
            alignment: const Alignment(0.9, 1.3),
            child: MyButtonWidget(
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
              buttonColor: Colors.transparent,
              content: const Text('Profili Düzenle'),
              context: context,
              height: 30,
              width: 100,
              borderColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class begeniContainer extends StatelessWidget {
  const begeniContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}

class medyaContainer extends StatelessWidget {
  const medyaContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}

class oneCikanlarContainer extends StatelessWidget {
  const oneCikanlarContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}

class yanitlarContainer extends StatelessWidget {
  const yanitlarContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}

class tweetContainer extends StatelessWidget {
  const tweetContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
