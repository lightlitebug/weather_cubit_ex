import 'package:meta/meta.dart';
import 'package:weather_cubit_ex/models/weather.dart';
import 'package:weather_cubit_ex/repositories/weather_api_client.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    print('city in getWeather: $city');
    final int locationId = await weatherApiClient.getLocationId(city);
    print('locationId: $locationId');
    return weatherApiClient.fetchWeather(locationId);
  }
}
