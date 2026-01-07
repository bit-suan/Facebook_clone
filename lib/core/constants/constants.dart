import 'package:facebook_clone/core/screens/profile_screen.dart';
import 'package:facebook_clone/core/screens/settings_screen.dart';
import 'package:facebook_clone/features/friends/presentation/screens/friends_screen.dart';
import 'package:facebook_clone/features/posts/presentation/screens/posts_screen.dart';
import 'package:facebook_clone/features/posts/presentation/screens/videos_screen.dart';
import 'package:flutter/material.dart';

class Constants {
  // Default padding for screens
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 10,
  );

  // demo profile urls
  static const String maleProfilePic =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  static const String profilePicBlank =
      'https://t3.ftcdn.net/jpg/05/16/27/58/240_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg';

  static List<Tab> getHomeScreenTabs(int index) {
    return [
      Tab(
        icon: Icon(
          index == 0 ? Icons.home : Icons.home_outlined,
          color: index == 0 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          index == 1 ? Icons.group : Icons.group_outlined,
          color: index == 1 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          index == 2 ? Icons.smart_display : Icons.smart_display_outlined,
          color: index == 2 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          index == 3 ? Icons.account_circle : Icons.account_circle_outlined,
          color: index == 3 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          index == 4 ? Icons.density_medium : Icons.density_medium_outlined,
          color: index == 4 ? Colors.blue : Colors.grey,
        ),
      ),
    ];
  }

  static const List<Widget> screens = [
    PostsScreen(),
    FriendsScreen(),
    VideosScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  Constants._();
}
