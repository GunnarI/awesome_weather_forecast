import 'package:flutter/material.dart';

import './pages/details/details_page.dart';
import './pages/location_search/location_search_page.dart';
import './pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Weather Forecast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LocationSearchPage.routeName: (context) => LocationSearchPage(),
        DetailsPage.routeName: (context) => DetailsPage(),
      },
    );
  }
}
