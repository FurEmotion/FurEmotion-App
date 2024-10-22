import 'package:babystory/enum/species.dart';
import 'package:babystory/providers/user_provider.dart';
import 'package:babystory/screens/detect_cry/main.dart';
import 'package:babystory/screens/setting.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavBarRouter extends StatefulWidget {
  const NavBarRouter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarRouterState createState() => _NavBarRouterState();
}

class _NavBarRouterState extends State<NavBarRouter> {
  var controller = PersistentTabController(initialIndex: 3);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    // for fullscreen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return FutureBuilder(
      future: _auth.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          context.read<UserProvider>().setUser(snapshot.data!);
          // snapshot.data!.printUserinfo();
          return PersistentTabView(
            context,
            controller: controller,
            navBarStyle: NavBarStyle.style3,
            screens: const [
              DetectCryMainScreen(
                  species: Species.cat, key: ValueKey('DetectCatCry')),
              DetectCryMainScreen(
                  species: Species.dog, key: ValueKey('DetectDogCry')),
              Setting(key: ValueKey('Setting')),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const FaIcon(FontAwesomeIcons.cat),
                title: 'Cat',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const FaIcon(FontAwesomeIcons.dog),
                title: 'Dog',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.settings),
                title: 'Setting',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
