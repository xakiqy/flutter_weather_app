class City {
  final double id;
  final String name;
  final String state;
  final String country;
  final double lon;
  final double lat;

  City({this.id, this.name, this.state, this.country, this.lon, this.lat});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'country': country,
      'lon': lon,
      'lat': lat,
    };
  }
}
