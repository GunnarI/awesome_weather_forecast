import 'package:flutter/material.dart';

import '../../models/geo_location.dart';

class LocationSearchPage extends StatelessWidget {
  static const routeName = '/location-search';

  const LocationSearchPage({Key? key}) : super(key: key);

  // TODO: Remove test lists below
  static const List<GeoLocation> _geoLocationList = <GeoLocation>[
    GeoLocation(
      location: 'Reykjavik',
      countryCode: 'IS',
      latitude: 64.145981,
      longitude: -21.9422367,
    ),
    GeoLocation(
      location: 'Akureyri',
      countryCode: 'IS',
      latitude: 65.68390355,
      longitude: -18.11217559813441,
    ),
  ];

  Iterable<GeoLocation> _locationSearchOptionsBuilder(
      TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const Iterable<GeoLocation>.empty();
    }
    return _geoLocationList.where((GeoLocation option) {
      return option
          .toString()
          .toLowerCase()
          .contains(textEditingValue.text.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search location'),
      ),
      body: Autocomplete<GeoLocation>(
                optionsBuilder: (textEditingValue) =>
                    _locationSearchOptionsBuilder(textEditingValue),
                onSelected: (locationSelected) {
                  // TODO: Use selected location to then search for weather data in location
                  print('Location selected: ${locationSelected.location}');
                },
              ),
    );
  }
}
