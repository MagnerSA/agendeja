import 'package:agendeja/home.dart';
import 'package:flutter/material.dart';

import '../login.dart';

const routeLogin = '/login';

const routeTests = '/tests';
const routeHome = '/home';

Map<String, Widget Function(BuildContext)> routes = {
  routeLogin: (context) => const LoginPage(),
  routeHome: (context) => const Home(),
  // routeTests: (context) => const TestsPage(),
};

navigateToLogin(context) async {
  Navigator.popAndPushNamed(context, routeLogin);
}
