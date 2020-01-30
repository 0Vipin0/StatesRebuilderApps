import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'Data/WeatherRepository.dart';
import 'State/WeatherStore.dart';
import 'Screens/WeatherSearchScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<WeatherStore>(() => WeatherStore(FakeWeatherRepository())),
        ],
        builder: (context) => WeatherSearchScreen(),
      ),
    );
  }
}
