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
  final String userId;
  final ProfileCubit viewModel;
  const ProfileView({super.key, required this.viewModel, required this.userId});
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
              return _buildSuccess(context);
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

  Widget _buildSuccess(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(viewModel.userModel.data!.name,
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _profileHeader(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constants.USER.name, style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                          '@${viewModel.userModel.data!.username}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray),
                        ),
                        const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                        Text((viewModel.userModel.data!.bio == ''
                            ? 'Biyografi bilgisi bulunmamaktadır.'
                            : viewModel.userModel.data!.bio)),
                        const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop, size: 20),
                              Text((viewModel.userModel.data!.location == ''
                                  ? 'Konum bilgisi bulunmamaktadır.'
                                  : 'Konum, Konum'))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            children: [const Icon(Icons.cake, size: 20), Text(viewModel.userModel.data!.birthday)],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 20),
                              Text(viewModel.userModel.data!.accountCreationDate)
                            ],
                          ),
                        ),
                        const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                        Row(
                          children: [
                            Text('${viewModel.userModel.data!.following.length} Takip edilen'),
                            const Box(size: BoxSize.MEDIUM, type: BoxType.HORIZONTAL),
                            Text('${viewModel.userModel.data!.followers.length} Takipçi'),
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
                          Expanded(
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
              ),
            ),
          )),
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
              bottom: 0.0,
              right: 300.0,
              child: CustomCircleAvatar(photoUrl: viewModel.userModel.data!.profilePhoto, radius: 40)),
          Align(
            alignment: const Alignment(0.9, 1.3),
            child: (viewModel.userModel.data!.userId == Constants.USER.userId)
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
                      Navigator.pushNamed(context, '/edit');
                    },
                    buttonColor: Colors.transparent,
                    content: const Text('Takip et'),
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

  Widget tweetContainer() {
    if (viewModel.tweetResource.data == null) {
      return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
    }
    return SizedBox(
      height: 600,
      child: TweetListViewContainer(
        resource: viewModel.tweetResource,
        userModel: viewModel.userModel.data!,
      ),
    );
  }

  Widget yanitlarContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Yanıtınız bulunmamaktadır.')),
    );
  }

  Widget oneCikanlarContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('One Cıkanlarınız bulunmamaktadır.')),
    );
  }

  Widget medyaContainer() {
    if (viewModel.mediaResource.data == null) {
      return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
    }
    return mediaListViewContainer(viewModel.mediaResource);
  }

  Widget begeniContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Begeniniz bulunmamaktadır.')),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            body: Center(
          child: Text('Profile Error'),
        )));
  }
}
