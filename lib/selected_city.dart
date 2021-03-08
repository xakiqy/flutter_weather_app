import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/current_weather.dart';
import 'package:weather_app/screen_size_reducer.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/util/util.dart';

import 'chart.dart';
import 'home.dart';
import 'model/city.dart';

class SelectedCityPage extends StatefulWidget {
  final City city;

  SelectedCityPage({Key? key, required this.city});

  @override
  _SelectedCityPageState createState() => _SelectedCityPageState();
}

class _SelectedCityPageState extends State<SelectedCityPage> {
  Future? weeklyAndHourlyWeather;

  @override
  void initState() {
    super.initState();
    weeklyAndHourlyWeather = fetchWeeklyDailyWeather(
        Coordinates(lon: widget.city.lon, lat: widget.city.lat));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      child: selectedCityPageTab(),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) Navigator.pop(context);
      },
    ));
  }

  Widget selectedCityPageTab() {
    final ThemeData theme = Theme.of(context);
    return FutureBuilder<WeekAndHourlyWeather>(
        future: weeklyAndHourlyWeather as Future<WeekAndHourlyWeather>?,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.hourly!.sort((a, b) => a.dt!.compareTo(b.dt!));
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(weatherBackGround(
                          snapshot.data!.current!.weather![0].main!)),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topHeader(snapshot.data!, theme),
                  Text(
                    'Daily temperature',
                    style: theme.textTheme.headline5,
                  ),
                  TodayChartTemperature(
                      hourly: snapshot.data!.hourly!.sublist(0, 24)),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                      height: screenHeight(context, dividedBy: 5),
                      child: bottomCardWeekWeather(snapshot.data!.daily)),
                ],
              ),
            );
          } else if (snapshot.hasError) return Text('${snapshot.error}');
          return CircularProgressIndicator();
        });
  }

  Widget topHeader(WeekAndHourlyWeather weekAndHourlyWeather, ThemeData theme) {
    return Container(
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
                      widget.city.name == null
                          ? ''
                          : widget.city.name.toString(),
                      style: theme.textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  weekAndHourlyWeather.current!.temp == null
                      ? ''
                      : 'temperature ' +
                          weekAndHourlyWeather.current!.temp!.ceil().toString(),
                  style: theme.textTheme.headline4,
                ),
                Text(
                  weekAndHourlyWeather.current!.feelsLike == null
                      ? ''
                      : 'feels like ' +
                          weekAndHourlyWeather.current!.feelsLike!
                              .ceil()
                              .toString(),
                  style: theme.textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    weekAndHourlyWeather.current!.weather![0].description == null
                        ? ''
                        : weekAndHourlyWeather.current!.weather![0].description!,
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
                  weatherImage(weekAndHourlyWeather.current!.weather![0].main!)),
              height: screenHeight(context, dividedBy: 10),
              width: screenWidth(context, dividedBy: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomCardWeekWeather(List<Daily>? dailies) {
    return Container(
      height: screenHeight(context, dividedBy: 3.5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _buildWeatherList(context, dailies),
      ),
    );
  }

  List<SizedBox> _buildWeatherList(BuildContext context, List<Daily>? dailies) {
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
                      daily.dt!.toInt() * 1000)),
                  style: theme.textTheme.headline6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(
                    image: AssetImage(weatherImage(daily.weather![0].main!)),
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
                          : 'max' + daily.temp!.max.toString(),
                      style: theme.textTheme.bodyText2!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      daily == null ? '' : 'min ' + daily.temp!.min.toString(),
                      style: theme.textTheme.bodyText2!
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
