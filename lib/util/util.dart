String weatherBackGround(String currentWeather) {
  var assetPath = 'assets/sunny_weather.png';
  if (currentWeather.toLowerCase() == 'clear') {
    assetPath = 'assets/sunny_weather.png';
  } else if (currentWeather.toLowerCase() == 'rain' ||
      currentWeather.toLowerCase() == 'snow' ||
      currentWeather.toLowerCase() == 'thunderstorm') {
    assetPath = 'assets/bad_weather.png';
  } else if (currentWeather.toLowerCase() == 'atmosphere' ||
      currentWeather.toLowerCase() == 'clouds' ||
      currentWeather.toLowerCase() == 'drizzle') {
    assetPath = 'assets/cloud_weather.png';
  }
  return assetPath;
}

String weatherImage(String currentWeather) {
  var assetPath = 'assets/clouds.png';
  if (currentWeather.toLowerCase() == 'clear') {
    assetPath = 'assets/sunny.png';
  } else if (currentWeather.toLowerCase() == 'rain') {
    assetPath = 'assets/rain.png';
  } else if (currentWeather.toLowerCase() == 'snow') {
    assetPath = 'assets/snow.png';
  } else if (currentWeather.toLowerCase() == 'thunderstorm') {
    assetPath = 'assets/thunderstorm.png';
  } else if (currentWeather.toLowerCase() == 'clouds' ||
      currentWeather.toLowerCase() == 'atmosphere') {
    assetPath = 'assets/clouds.png';
  } else if (currentWeather.toLowerCase() == 'drizzle') {
    assetPath = 'assets/drizzle.png';
  }
  return assetPath;
}

double checkDouble(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is String) {
    return double.parse(value);
  } else if (value is int) {
    return value.toDouble();
  }
  return 0.0;
}
