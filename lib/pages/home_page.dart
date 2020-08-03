import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_cubit_ex/cubits/settings_cubit.dart';

import 'package:weather_cubit_ex/cubits/weather_cubit.dart';

import 'package:weather_cubit_ex/pages/settings_page.dart';
import 'package:weather_cubit_ex/pages/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<void> _refreshCompleter;
  String city;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  String calcuateTemp(TemperatureUnit tempUnit, double temperature) {
    if (tempUnit == TemperatureUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }
    return temperature.toStringAsFixed(2) + '℃';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsPage();
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                city = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchPage();
                    },
                  ),
                );
                if (city != null) {
                  BlocProvider.of<WeatherCubit>(context).fetchWeather(city);
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.weather != null) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state == WeatherCubit.initialWeatherState) {
              return Center(
                child: Text(
                  'Select a city',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            if (state.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.weather != null) {
              return RefreshIndicator(onRefresh: () {
                if (city != null) {
                  BlocProvider.of<WeatherCubit>(context).fetchWeather(city);
                }
                return _refreshCompleter.future;
              }, child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settings) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                      Text(
                        state.weather.city,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 60.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            calcuateTemp(settings.temperatureUnit,
                                state.weather.theTemp),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Max: ' +
                                    calcuateTemp(settings.temperatureUnit,
                                        state.weather.maxTemp),
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Min: ' +
                                    calcuateTemp(settings.temperatureUnit,
                                        state.weather.minTemp),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '${state.weather.weatherStateName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ],
                  );
                },
              ));
            }

            return Center(
              child: Text(
                state.error,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          },
        ));
  }
}
