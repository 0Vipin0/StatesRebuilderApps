import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../Data/Model/Weather.dart';
import '../State/WeatherStore.dart';
import '../Screens/WeatherSearchScreen.dart';

class WeatherDisplayScreen extends StatefulWidget {
  @override
  _WeatherDisplayScreenState createState() => _WeatherDisplayScreenState();
}

class _WeatherDisplayScreenState extends State<WeatherDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return StateBuilder<WeatherStore>(
      models: [Injector.getAsReactive<WeatherStore>()],
      builder: (context, reactiveModel) => reactiveModel.whenConnectionState(
        onIdle: () => buildLoading(),
        onWaiting: () => buildLoading(),
        onData: (store) => buildColumnWithData(store.weather),
        onError: (_) => buildLoading(),
      ),
    );
  }

  Widget buildLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildColumnWithData(Weather weather) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          weather.cityName ?? "Empty Value",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // Display the temperature with 1 decimal place
              weather.cityName == null
                  ? "Error"
                  : "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
              style: TextStyle(fontSize: 80),
            ),
            RaisedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Injector(
                    reinject: [Injector.getAsReactive<WeatherStore>()],
                    builder: (context) => WeatherSearchScreen(),
                  ),
                ),
              ),
              child: Text("Go Back to main Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
