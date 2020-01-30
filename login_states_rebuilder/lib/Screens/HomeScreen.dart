import 'package:flutter/material.dart';
import 'package:login_states_rebuilder/Data/Model/User.dart';
import 'package:login_states_rebuilder/State/UserStore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomeScreen extends StatefulWidget {
  static String route = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context).settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        body: StateBuilder<UserStore>(
          models: [Injector.getAsReactive<UserStore>()],
          builder: (context, reactiveModel) =>
              reactiveModel.whenConnectionState(
            onIdle: () => buildLoading(),
            onWaiting: () => buildLoading(),
            onData: (store) =>
                buildScreen(store.findUserById(userId), userId),
            onError: null,
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildScreen(User user, String id) {
    return Column(
      children: <Widget>[
        Text(user.toString()),
        Text(id ?? "Empty"),
      ],
    );
  }
}
