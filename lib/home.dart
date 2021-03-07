import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/cities_weather.dart';
import 'package:weather_app/model/current_weather.dart';
import 'package:weather_app/screen_size_reducer.dart';
import 'package:weather_app/service/weather_service.dart';
import 'chart.dart';
import 'service/extensions.dart';

class HomePage extends StatefulWidget {
  final Cities cityWeather;

  HomePage({Key key, @required this.cityWeather});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future weeklyAndHourlyWeather;

  @override
  void initState() {
    super.initState();
    weeklyAndHourlyWeather = fetchWeeklyDailyWeather(widget.cityWeather.coord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: homePageTab());
  }

  Widget homePageTab() {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    weatherBackGround(widget.cityWeather.weather[0].main)),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Hero(
              tag: widget.cityWeather.name,
              child: Container(
                height: screenHeight(context, dividedBy: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: screenWidth(context, dividedBy: 2),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.cityWeather.name == null
                                    ? ''
                                    : widget.cityWeather.name.toString(),
                                style: theme.textTheme.headline5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            widget.cityWeather.main.temp == null
                                ? ''
                                : 'temperature ' +
                                    widget.cityWeather.main.temp
                                        .ceil()
                                        .toString(),
                            style: theme.textTheme.headline4,
                          ),
                          Text(
                            widget.cityWeather.main.feelsLike == null
                                ? ''
                                : 'feels like ' +
                                    widget.cityWeather.main.feelsLike
                                        .ceil()
                                        .toString(),
                            style: theme.textTheme.headline4,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.cityWeather.weather[0].description == null
                                  ? ''
                                  : widget.cityWeather.weather[0].description,
                              style: theme.textTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image(
                        image: AssetImage(
                            weatherImage(widget.cityWeather.weather[0].main)),
                        height: screenHeight(context, dividedBy: 10),
                        width: screenWidth(context, dividedBy: 4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<WeekAndHourlyWeather>(
                future: weeklyAndHourlyWeather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.hourly.sort((a, b) => a.dt.compareTo(b.dt));
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily temperature',
                          style: theme.textTheme.headline5,
                        ),
                        TodayChartTemperature(
                            hourly: snapshot.data.hourly.sublist(0, 24)),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                            height: screenHeight(context, dividedBy: 5),
                            child: bottomCardWeekWeather(snapshot.data.daily)),
                      ],
                    );
                  } else if (snapshot.hasError)
                    return Text('${snapshot.error}');
                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) Navigator.pop(context);
      },
    );
  }

  Widget header(BuildContext context, CurrentWeather currentWeather) {
    return Container(
      height: screenHeight(context, dividedBy: 3),
      width: screenWidth(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 4.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Temperature: ' + currentWeather.main.temp.toString(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Feels like: ' + currentWeather.main.feelsLike.toString(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      currentWeather.weather[0].description.capitalize(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(currentWeather.name,
                      style: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 32.0, 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(weatherImage(currentWeather.weather[0].main),
                      width: screenWidth(
                        context,
                        dividedBy: 4,
                      ),
                      height: screenHeight(
                        context,
                        dividedBy: 4,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomCardWeekWeather(List<Daily> dailies) {
    return Container(
      height: screenHeight(context, dividedBy: 3.5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _buildWeatherList(context, dailies),
      ),
    );
  }

  List<SizedBox> _buildWeatherList(BuildContext context, List<Daily> dailies) {
    if (dailies == null || dailies.isEmpty) {
      return const <SizedBox>[];
    }

    final ThemeData theme = Theme.of(context);

    return dailies.map((daily) {
      return SizedBox(
        width: screenWidth(context, dividedBy: 3),
        height: screenHeight(context, dividedBy: 3.5),
        child: Card(
          color: Color(0x00000000),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(
                      daily.dt.toInt() * 1000)),
                  style: theme.textTheme.headline6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(
                    image: AssetImage(weatherImage(daily.weather[0].main)),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      daily == null
                          ? 'max '
                          : 'max' + daily.temp.max.toString(),
                      style: theme.textTheme.bodyText2
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      daily == null ? '' : 'min ' + daily.temp.min.toString(),
                      style: theme.textTheme.bodyText2
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

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
