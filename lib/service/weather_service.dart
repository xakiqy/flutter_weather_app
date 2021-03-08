import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/cities_weather.dart';
import 'geolocation_service.dart';
import 'package:weather_app/model/current_weather.dart';

Future<CitiesWeather> fetchNearestCitiesWeather() async {
  var coordinates = await determinePosition();

  final uri = Uri.http('api.openweathermap.org', 'data/2.5/find', {
    'lat': coordinates.latitude.toString(),
    'lon': coordinates.longitude.toString(),
    'units': 'metric',
    'appid': '885c1685ede610d233a586cfe3ddc23e',
    'cnt': '10'
  });

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CitiesWeather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weather');
  }
}

Future<WeekAndHourlyWeather> fetchWeeklyDailyWeather(
    Coordinates coordinates) async {
  final uri = Uri.http('api.openweathermap.org', '/data/2.5/onecall', {
    'lat': coordinates.lat.toString(),
    'lon': coordinates.lon.toString(),
    'exclude': 'minutely',
    'units': 'metric',
    'appid': '885c1685ede610d233a586cfe3ddc23e'
  });

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WeekAndHourlyWeather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weather');
  }
}

Future<CurrentWeather> fetchCurrentWeather() async {
  var coordinates = await determinePosition();

  final uri = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
    'lat': coordinates.latitude.toString(),
    'lon': coordinates.longitude.toString(),
    'units': 'metric',
    'appid': '885c1685ede610d233a586cfe3ddc23e'
  });

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CurrentWeather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weather');
  }
}
