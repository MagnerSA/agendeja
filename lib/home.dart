import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'services/user.service.dart';
import 'style/colors.dart';
import 'style/sizes.dart';
import 'widgets/squaredIconPanel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserService userService = UserService();

  Map<String, dynamic> userInfo = {};

  @override
  initState() {
    initPage();
    super.initState();
  }

  initPage() async {
    await _auth();

    userInfo = await userService.getCurrentUser();

    setState(() {});
  }

  _auth() async {
    bool isUserLogged = await userService.isUserLogged();

    if (!isUserLogged) {
      navigateToLogin(context);
    }
  }

  _widgetTopBar() {
    return SizedBox(
      height: getSizeHeight(context),
      child: Row(
        children: [
          SquaredIconPanel(
            onTap: () {
              userService.logout();
              navigateToLogin(context);
            },
            iconData: Icons.power_settings_new,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: Padding(
        padding: EdgeInsets.all(getSizeSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetTopBar(),
          ],
        ),
      ),
    );
  }
}
