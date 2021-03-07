import 'package:flutter/cupertino.dart';
import 'package:weather_app/service/city_service.dart';

import 'city.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<City> _suggestions = [];

  List<City> get suggestions => _suggestions;

  String _query = '';

  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = [];
    } else {
      _suggestions = await getCitiesByLetters(query);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = [];
    notifyListeners();
  }
}
