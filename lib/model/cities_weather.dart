import 'current_weather.dart';

class CitiesWeather {
  List<Cities> cities;

  CitiesWeather({this.cities});

  CitiesWeather.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      cities = [];
      json['list'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cities != null) {
      data['list'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String name;
  Coordinates coord;
  Main main;
  List<Weather> weather;

  Cities({this.name, this.coord, this.main, this.weather});

  Cities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    coord =
        json['coord'] != null ? new Coordinates.fromJson(json['coord']) : null;
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.coord != null) {
      data['coord'] = this.coord.toJson();
    }
    if (this.main != null) {
      data['main'] = this.main.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
