import 'package:flutter/material.dart';
import 'package:login_states_rebuilder/Data/UserRepository.dart';
import 'package:login_states_rebuilder/Screens/HomeScreen.dart';
import 'package:login_states_rebuilder/Screens/SignUpScreen.dart';
import 'package:login_states_rebuilder/State/UserStore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'Screens/SignInScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login using States Rebuilder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Injector(
        inject: [
          Inject<UserStore>(() => UserStore(FakeUserRepository())),
        ],
        builder: (context) => SignInScreen(),
      ),
      routes: {
        SignInScreen.route: (context) => SignInScreen(),
        SignUpScreen.route:(context)=>SignUpScreen(),
        HomeScreen.route:(context)=>HomeScreen(),
      },
    );
  }
}
