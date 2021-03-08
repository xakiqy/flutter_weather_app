import 'package:weather_app/util/util.dart';

class MinMaxModel {
  double? min;
  double? max;

  MinMaxModel({this.min, this.max});
}

class WeekAndHourlyWeather {
  double? lat;
  double? lon;
  String? timezone;
  double? timezoneOffset;
  Current? current;
  List<Hourly>? hourly;
  List<Daily>? daily;

  WeekAndHourlyWeather(
      {this.lat,
      this.lon,
      this.timezone,
      this.timezoneOffset,
      this.current,
      this.hourly,
      this.daily});

  WeekAndHourlyWeather.fromJson(Map<String, dynamic> json) {
    lat = checkDouble(json['lat']);
    lon = checkDouble(json['lon']);
    timezone = json['timezone'];
    timezoneOffset = checkDouble(json['timezone_offset']);
    current =
        json['current'] != null ? new Current.fromJson(json['current']) : null;
    if (json['hourly'] != null) {
      hourly = [];
      json['hourly'].forEach((v) {
        hourly!.add(new Hourly.fromJson(v));
      });
    }
    if (json['daily'] != null) {
      daily = [];
      json['daily'].forEach((v) {
        daily!.add(new Daily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['timezone'] = this.timezone;
    data['timezone_offset'] = this.timezoneOffset;
    if (this.current != null) {
      data['current'] = this.current!.toJson();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly!.map((v) => v.toJson()).toList();
    }
    if (this.daily != null) {
      data['daily'] = this.daily!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  double? dt;
  double? temp;
  double? feelsLike;
  double? windSpeed;
  List<Weather>? weather;

  Current({
    this.dt,
    this.temp,
    this.feelsLike,
    this.windSpeed,
    this.weather,
  });

  Current.fromJson(Map<String, dynamic> json) {
    dt = checkDouble(json['dt']);
    temp = checkDouble(json['temp']);
    feelsLike = checkDouble(json['feels_like']);
    windSpeed = checkDouble(json['wind_speed']);
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['wind_speed'] = this.windSpeed;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  String? main;
  String? description;

  Weather({this.main, this.description});

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main'] = this.main;
    data['description'] = this.description;
    return data;
  }
}

class Hourly {
  double? dt;
  double? temp;
  double? feelsLike;
  double? windSpeed;
  List<Weather>? weather;

  Hourly({
    this.dt,
    this.temp,
    this.feelsLike,
    this.windSpeed,
    this.weather,
  });

  Hourly.fromJson(Map<String, dynamic> json) {
    dt = checkDouble(json['dt']);
    temp = checkDouble(json['temp']);
    feelsLike = checkDouble(json['feels_like']);
    windSpeed = checkDouble(json['wind_speed']);
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['wind_speed'] = this.windSpeed;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Daily {
  double? dt;
  Temp? temp;
  double? windSpeed;
  List<Weather>? weather;

  Daily({
    this.dt,
    this.temp,
    this.windSpeed,
    this.weather,
  });

  Daily.fromJson(Map<String, dynamic> json) {
    dt = checkDouble(json['dt']);
    temp = json['temp'] != null ? new Temp.fromJson(json['temp']) : null;
    windSpeed = checkDouble(json['wind_speed']);
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    if (this.temp != null) {
      data['temp'] = this.temp!.toJson();
    }
    data['wind_speed'] = this.windSpeed;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Temp {
  double? day;
  double? min;
  double? max;

  Temp({this.day, this.min, this.max});

  Temp.fromJson(Map<String, dynamic> json) {
    day = checkDouble(json['day']);
    min = checkDouble(json['min']);
    max = checkDouble(json['max']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['min'] = this.min;
    data['max'] = this.max;
    return data;
  }
}

class CurrentWeather {
  Coordinates? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  double? visibility;
  Wind? wind;
  Clouds? clouds;
  String? name;

  CurrentWeather({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.name,
  });

  CurrentWeather.fromJson(Map<String, dynamic> json) {
    coord =
        json['coord'] != null ? new Coordinates.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
    base = json['base'];
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
    visibility = checkDouble(json['visibility']);
    wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
    clouds =
        json['clouds'] != null ? new Clouds.fromJson(json['clouds']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    data['base'] = this.base;
    if (this.main != null) {
      data['main'] = this.main!.toJson();
    }
    data['visibility'] = this.visibility;
    if (this.wind != null) {
      data['wind'] = this.wind!.toJson();
    }
    if (this.clouds != null) {
      data['clouds'] = this.clouds!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Coordinates {
  double? lon;
  double? lat;

  Coordinates({this.lon, this.lat});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lon = checkDouble(json['lon']);
    lat = checkDouble(json['lat']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? pressure;
  double? humidity;

  Main({this.temp, this.feelsLike, this.pressure, this.humidity});

  Main.fromJson(Map<String, dynamic> json) {
    temp = checkDouble(json['temp']);
    feelsLike = checkDouble(json['feels_like']);
    pressure = checkDouble(json['pressure']);
    humidity = checkDouble(json['humidity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    return data;
  }
}

class Wind {
  double? speed;
  double? deg;

  Wind({this.speed, this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = checkDouble(json['speed']);
    deg = checkDouble(json['deg']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speed'] = this.speed;
    data['deg'] = this.deg;
    return data;
  }
}

class Clouds {
  double? all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = checkDouble(json['all']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    return data;
  }
}
