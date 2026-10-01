import 'location.dart';
import 'networking.dart';
import 'weather_model.dart';

class WeatherService {
  final String apiKey = 'fba4cbcf571a9842798ee4624616e678';

  Future<WeatherModel> getWeatherByLocation() async {
    Location location = Location();

    await location.getCurrentLocation();

    String url =
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${location.latitude}'
        '&lon=${location.longitude}'
        '&appid=$apiKey'
        '&units=metric';

    Networking networking = Networking(url);

    dynamic data = await networking.getData();

    return WeatherModel.fromJson(data);
  }

  Future<WeatherModel> getWeatherByCity(
      String city,
      ) async {
    String url =
        'https://api.openweathermap.org/data/2.5/weather'
        '?q=$city'
        '&appid=$apiKey'
        '&units=metric';

    Networking networking = Networking(url);

    dynamic data = await networking.getData();

    return WeatherModel.fromJson(data);
  }
}