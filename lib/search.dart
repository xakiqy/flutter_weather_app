import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screen_size_reducer.dart';
import 'package:weather_app/selected_city.dart';
import 'package:weather_app/service/weather_service.dart';

import 'home.dart';
import 'model/cities_weather.dart';
import 'model/city.dart';
import 'model/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future citiesWeather;
  final searchController = FloatingSearchBarController();
  String searchQuery = "Search query";

  @override
  void initState() {
    super.initState();
    citiesWeather = fetchNearestCitiesWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: buildSearchBar());
  }

  Widget bottomCardWeekWeather(List<Cities> cities) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: _buildWeatherList(context, cities),
    );
  }

  List<GestureDetector> _buildWeatherList(
      BuildContext context, List<Cities> cities) {
    if (cities == null || cities.isEmpty) {
      return const <GestureDetector>[];
    }

    return cities.map((cityWeather) {
      return cityWeatherCard(context, cityWeather);
    }).toList();
  }

  GestureDetector cityWeatherCard(BuildContext context, Cities cityWeather) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: screenHeight(context, dividedBy: 5),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              child: Hero(
                tag: cityWeather.name,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              weatherBackGround(cityWeather.weather[0].main)),
                          fit: BoxFit.fill)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                cityWeather.name == null
                                    ? ''
                                    : cityWeather.name.toString(),
                                style: theme.textTheme.headline6,
                              ),
                            ),
                            Text(
                              cityWeather.main.temp == null
                                  ? ''
                                  : 'temperature ' +
                                      cityWeather.main.temp.ceil().toString(),
                              style: theme.textTheme.bodyText1,
                            ),
                            Text(
                              cityWeather.main.feelsLike == null
                                  ? ''
                                  : 'feels like ' +
                                      cityWeather.main.feelsLike
                                          .ceil()
                                          .toString(),
                              style: theme.textTheme.bodyText1,
                            ),
                            Text(
                              cityWeather.weather[0].description == null
                                  ? ''
                                  : cityWeather.weather[0].description,
                              style: theme.textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage(
                              weatherImage(cityWeather.weather[0].main)),
                          height: screenHeight(context, dividedBy: 10),
                          width: screenWidth(context, dividedBy: 4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HomePage(cityWeather: cityWeather);
          }));
        });
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchModel>(
      builder: (context, model, _) => FloatingSearchBar(
        queryStyle: ThemeData.light().textTheme.headline5,
        automaticallyImplyBackButton: false,
        controller: searchController,
        clearQueryOnClose: true,
        hint: searchQuery,
        iconColor: Colors.grey,
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait ? 600 : 500,
        actions: actions,
        progress: model.isLoading,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, _) => buildExpandableBody(model),
        body: Column(
          children: [
            SizedBox(height: screenHeight(context, dividedBy: 10)),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return SizedBox(
      height: screenHeight(context,
          reducedBy: screenHeight(context, dividedBy: 10)),
      child: FutureBuilder<CitiesWeather>(
          future: citiesWeather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return bottomCardWeekWeather(snapshot.data.cities);
            } else if (snapshot.hasError) return Text('${snapshot.error}');
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildExpandableBody(SearchModel model) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<City>(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        items: model.suggestions.take(6).toList(),
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, place, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, place),
          );
        },
        updateItemBuilder: (context, animation, place) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, place),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, City city) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.copyWith();

    final model = Provider.of<SearchModel>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return SelectedCityPage(city: city);
            }));
            FloatingSearchBar.of(context).close();
            Future.delayed(
              const Duration(milliseconds: 2000),
              () => model.clear(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: model.suggestions == []
                        ? const Icon(Icons.history, key: Key('history'))
                        : const Icon(Icons.place, key: Key('place')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: textTheme.headline6
                            .copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        city.country,
                        style: textTheme.bodyText2
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.suggestions.isNotEmpty && city != model.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }
}
