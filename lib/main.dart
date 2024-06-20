import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'routes/routes.dart';

// const FirebaseOptions firebaseConfig = {
//   // apiKey: "AIzaSyAaVZwSR8y1BPGPGUhLmBUwJb7V31ZhkjA",
//   // authDomain: "projeto-agendeja.firebaseapp.com",
//   // projectId: "projeto-agendeja",
//   // storageBucket: "projeto-agendeja.appspot.com",
//   // messagingSenderId: "383398987488",
//   // appId: "1:383398987488:web:7d5809a5cc66fd5d1af285"
// };

void main() async {
  await Firebase.initializeApp(
    // options: firebaseConfig
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Demo',
      initialRoute: routeLogin,
      routes: routes,
    );
  }
}
