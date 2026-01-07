import 'package:facebook_clone/features/chat/presentation/screens/chat_screen.dart';
import 'package:facebook_clone/features/story/presentation/screens/create_story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/constants.dart';
import '/core/constants/extensions.dart';
import '/core/screens/error_screen.dart';
import '/core/screens/loader.dart';
import '/core/widgets/round_button.dart';
import '/features/auth/providers/get_user_info_as_stream_by_id_provider.dart';
import '/features/friends/presentation/widgets/add_friend_button.dart';
import '/features/posts/presentation/widgets/icon_text_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    this.userId,
  });

  final String? userId;

  static const routeName = '/profile';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final uid = widget.userId ?? myUid;
    final userInfo = ref.watch(getUserInfoAsStreamByIdProvider(uid));

    return userInfo.when(
      data: (user) {
        return SafeArea(
          child: Scaffold(
            appBar: uid != myUid
                ? AppBar(
                    title: const Text('Profile Screen'),
                  )
                : null,
            backgroundColor: AppColors.whiteColor,
            body: Padding(
              padding: Constants.defaultPadding,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profilePicUrl),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 20),
                  uid == myUid
                      ? RoundButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CreateStoryScreen.routeName,
                            );
                          },
                          label: 'Add to Story',
                        )
                      : AddFriendButton(
                          user: user,
                        ),
                  const SizedBox(height: 10),
                  if (uid != myUid)
                    RoundButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ChatScreen.routeName,
                          arguments: {
                            'userId': uid,
                          },
                        );
                      },
                      label: 'Send Message',
                      color: Colors.transparent,
                    ),
                  const SizedBox(height: 20),
                  _buildProfileInfo(
                    email: user.email,
                    gender: user.gender,
                    birthday: user.birthDay,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                RoundButton(
                  onPressed: () {
                    ref.invalidate(getUserInfoAsStreamByIdProvider(uid));
                  },
                  label: 'Refresh Profile',
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const Loader();
      },
    );
  }

  RoundButton _buildAddToStoryButton() =>
      RoundButton(onPressed: () {}, label: 'Add to Story');

  Column _buildProfileInfo({
    required String email,
    required String gender,
    required DateTime birthday,
  }) =>
      Column(
        children: [
          IconTextButton(
            icon: gender == 'male' ? Icons.male : Icons.female,
            label: gender,
          ),
          const SizedBox(height: 10),
          IconTextButton(
            icon: Icons.cake,
            label: birthday.yMMMEd(),
          ),
          const SizedBox(height: 10),
          IconTextButton(
            icon: Icons.email,
            label: email,
          ),
        ],
      );
}
