// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_cubit.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import 'package:twitter/widget/tweet_containers_utils.dart';
import '../../utils/box_constants.dart';
import '../../utils/theme_utils.dart';
import '../../widget/box.dart';
import '../../widget/media_containers_utils.dart';

class ProfileView extends StatelessWidget {
  String userId;
  final ProfileCubit viewModel;
  ProfileView({super.key, required this.viewModel, required this.userId});
  // ProfileView({Key? key, required this.viewModel, required this.userId}) : super(key: key) {
  //   viewModel.getUserProfile(userId);
  // }
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    viewModel.getUserProfile(userId);
    // });

    return BlocProvider<ProfileCubit>(
        create: (_) => viewModel,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                viewModel.getUserProfile(userId);
              });
            }
          },
          builder: (context, state) {
            debugPrint('Profile view state: $state');
            if (state is ProfileInitial) {
              // return _buildInitial(context);
            }
            if (state is ProfileLoading) {
              return _buildLoading(context);
            } else if (state is ProfileSuccess) {
              // viewModel.getUserProfile(userId); // !!!
              return _buildSuccess(context, state);
            } else if (state is ProfileError) {
              return _buildError(context);
            }
            return Container();
          },
        ));
  }

  // Widget _buildScaffold(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text(viewModel.userModel.data!.name,
  //             style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
  //         centerTitle: false,
  //       ),
  //       backgroundColor: Colors.black,
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () async {
  //           await Navigator.pushNamed(context, '/tweet');
  //           viewModel.getUserProfile(userId);
  //         },
  //         backgroundColor: CustomColors.blue,
  //         child: SizedBox(
  //           width: 45, // Set the desired width
  //           height: 45, // Set the desired height
  //           child: Image.asset('assets/images/new_tweet.png'),
  //         ),
  //       ),
  //       body: const Center(
  //         child: Text('profile initial'),
  //       ));
  // }

  // Widget _buildInitial(BuildContext context) {
  //   // viewModel.getUserProfile(userId);
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text(viewModel.userModel.data!.name,
  //             style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
  //         centerTitle: false,
  //       ),
  //       backgroundColor: Colors.black,
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () async {
  //           await Navigator.pushNamed(context, '/tweet');
  //           viewModel.getUserProfile(userId);
  //         },
  //         backgroundColor: CustomColors.blue,
  //         child: SizedBox(
  //           width: 45, // Set the desired width
  //           height: 45, // Set the desired height
  //           child: Image.asset('assets/images/new_tweet.png'),
  //         ),
  //       ),
  //       body: const Center(
  //         child: Text('profile initial'),
  //       ));
  // }

  Widget _buildLoading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          // appBar: AppBar(
          //   title: Text(viewModel.userModel.data!.name,
          //       style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          //   centerTitle: false,
          // ),
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/tweet');
              viewModel.getUserProfile(userId);
            },
            backgroundColor: CustomColors.blue,
            child: SizedBox(
              width: 45, // Set the desired width
              height: 45, // Set the desired height
              child: Image.asset('assets/images/new_tweet.png'),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: LinearProgressIndicator(
                  color: CustomColors.blue,
                  backgroundColor: CustomColors.lightGray,
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildSuccess(BuildContext context, ProfileSuccess state) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(state.userModel.data!.name,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/tweet');
          viewModel.getUserProfile(userId);
        },
        backgroundColor: CustomColors.blue,
        child: SizedBox(
          width: 45, // Set the desired width
          height: 45, // Set the desired height
          child: Image.asset('assets/images/new_tweet.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileHeader(context, state),
            Container(height: 200, width: 200, child: _profileBio(state, context)),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: DefaultTabController(
                length: 5, // Number of tabs
                child: SizedBox(
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
                      Container(
                        child: TabBarView(
                          children: [
                            tweetContainer(state),
                            yanitlarContainer(state),
                            oneCikanlarContainer(state),
                            medyaContainer(state),
                            begeniContainer(state),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _profileBio(ProfileSuccess state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(state.userModel.data!.name, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            '@${state.userModel.data!.username}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray),
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          Text((state.userModel.data!.bio == '' ? 'Biyografi bilgisi bulunmamaktadır.' : state.userModel.data!.bio)),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Row(
              children: [
                const Icon(Icons.pin_drop, size: 20),
                Text((state.userModel.data!.location == '' ? 'Konum bilgisi bulunmamaktadır.' : 'Konum, Konum'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Row(
              children: [const Icon(Icons.cake, size: 20), Text(state.userModel.data!.birthday)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Row(
              children: [const Icon(Icons.calendar_month, size: 20), Text(state.userModel.data!.accountCreationDate)],
            ),
          ),
          const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
          Row(
            children: [
              Text('${state.userModel.data!.following.length} Takip edilen'), // bir tane hazır geliy
              const Box(size: BoxSize.MEDIUM, type: BoxType.HORIZONTAL),
              Text('${state.userModel.data!.followers.length} Takipçi'),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _profileHeader(BuildContext context, ProfileSuccess state) {
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
              bottom: 0.0,
              right: 300.0,
              child: CustomCircleAvatar(photoUrl: state.userModel.data!.profilePhoto, radius: 40)),
          Align(
            alignment: const Alignment(0.9, 1.3),
            child: (state.userModel.data!.userId == Constants.USER.userId)
                ? MyButtonWidget(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit');
                    },
                    buttonColor: Colors.transparent,
                    content: const Text('Profili Düzenle'),
                    context: context,
                    height: 30,
                    width: 100,
                    borderColor: Colors.white,
                  )
                : MyButtonWidget(
                    onPressed: () {
                      viewModel.updateFollowingList(userId);
                    },
                    buttonColor: Colors.transparent,
                    content: Text(state.isFollowing ? 'Takipten çık' : 'Takip et'),
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

  Widget tweetContainer(ProfileSuccess state) {
    if (state.tweetResource.data == null || state.tweetResource.data!.isEmpty) {
      if (state.userModel.data!.userId == Constants.USER.userId) {
        return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
      } else {
        return const Center(child: Text('Kullanıcının atılmış tweetini bulunmamaktadır.'));
      }
    }
    return SizedBox(
      child: Text('Burayı düzenle'),
      // child: TweetListViewContainer(
      //   tweetResource: state.tweetResource,
      //   baseViewModel: viewModel,
      // ),
    );
  }

  Widget yanitlarContainer(ProfileSuccess state) {
    return Container(
      color: Colors.black,
      child: Center(
          child: Text(state.userModel.data!.userId == Constants.USER.userId
              ? 'Yanıtınız bulunmamaktadır.'
              : 'Kullanıcının atılmış yanıtı bulunmamaktadır.')),
    );
  }

  Widget oneCikanlarContainer(ProfileSuccess state) {
    return Container(
      color: Colors.black,
      child: Center(
          child: Text(state.userModel.data!.userId == Constants.USER.userId
              ? 'One Cıkanlar bulunmamaktadır.'
              : 'Kullanıcının one cıkarılanları bulunmamaktadır.')),
    );
  }

  Widget medyaContainer(ProfileSuccess state) {
    if (state.tweetResource.data == null || state.tweetResource.data!.isEmpty) {
      return Center(
          child: Text(state.userModel.data!.userId == Constants.USER.userId
              ? 'Medyanız bulunmamaktadır.'
              : 'Kullanıcının medyası bulunmamaktadır.'));
    }
    debugPrint('routing to tweet container $state.me');
    return MediaListViewContainer(
      resource: state.mediaResource,
    );
  }

  Widget begeniContainer(ProfileSuccess state) {
    if (state.tweetResource.data == null || state.tweetResource.data!.isEmpty) {
      if (state.userModel.data!.userId == Constants.USER.userId) {
        return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
      } else {
        return const Center(child: Text('Kullanıcının atılmış tweetini bulunmamaktadır.'));
      }
    }
    debugPrint('begeni container : ${state.favTweetResource.data!.length.toString()}');
    return SizedBox(
      height: 300,
      child: Text('Burayı da  düzenle'),
      // child: TweetListViewContainer(
      //   tweetResource: state.favTweetResource,
      //   baseViewModel: viewModel,
      // ),
    );
  }

  // Widget begeniContainer(ProfileSuccess state) {
  //   return Container(
  //     color: Colors.black,
  //     child: Center(
  //         child: Text(state.userModel.data!.userId == Constants.USER.userId
  //             ? 'Begeniniz bulunmamaktadır.'
  //             : 'Kullanıcının begendikleri bulunmamaktadır.')),
  //   );
  // }

  Widget _buildError(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            body: Center(
          child: Text('Profile Error'),
        )));
  }
}
