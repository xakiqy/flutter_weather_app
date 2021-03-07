import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/search.dart';
import 'package:weather_app/theme/theme.dart';

import 'model/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather app',
        theme: weatherTheme,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: ChangeNotifierProvider(
              create: (_) => SearchModel(), child: SearchPage()),
        ));
  }
}
