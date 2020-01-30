import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:weather_state_rebuilder/Screens/WeatherDisplayScreen.dart';

import '../Data/Model/Weather.dart';
import '../Data/WeatherRepository.dart';
import '../State/WeatherStore.dart';

class WeatherSearchScreen extends StatefulWidget {
  @override
  _WeatherSearchScreenState createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: StateBuilder<WeatherStore>(
          models: [Injector.getAsReactive<WeatherStore>()],
          builder: (context, reactiveModel) =>
              reactiveModel.whenConnectionState(
            onIdle: () => buildInitialInput(),
            onWaiting: () => buildLoading(),
            onData: (store) => buildColumnWithData(store.weather),
            onError: (_) => buildInitialInput(),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CityInputForm(),
      ],
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName ?? "Empty Value",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          weather.cityName == null
              ? "Error"
              : "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputForm(),
        RaisedButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Injector(
                reinject: [Injector.getAsReactive<WeatherStore>()],
                builder: (context) => WeatherDisplayScreen(),
              ),
            ),
          ),
          child: Text("Display"),
        ),
      ],
    );
  }
}

class CityInputForm extends StatefulWidget {
  @override
  _CityInputFormState createState() => _CityInputFormState();
}

class _CityInputFormState extends State<CityInputForm> {
  String cityName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            onChanged: (value) => cityName = value,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Enter a city",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            submitCityName(context, cityName);
          },
          child: Text("Details"),
        ),
      ],
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    if (cityName != null) {
      Injector.getAsReactive<WeatherStore>().setState(
        (store) => store.getWeather(cityName),
        onError: (context, error) {
          if (error is NetworkError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Couldn't fetch weather. Is the device online?"),
              ),
            );
          } else {
            throw error;
          }
        },
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please Enter Something"),
      ));
    }
  }
}
