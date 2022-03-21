import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/repositories/weather_data_repository.dart';
import '/models/geo_location.dart';
import 'bloc/location_search_bloc.dart';

class LocationSearchPage extends StatelessWidget {
  static const routeName = '/location-search';

  const LocationSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search location'),
      ),
      body: TypeAheadField<GeoLocation>(
        keepSuggestionsOnLoading: false,
        suggestionsCallback: (searchValue) async {
          if (searchValue.isEmpty) return [];
          // TODO: Make sure it is also possible to search by other params (e.g. lat, lon, country)
          return await RepositoryProvider.of<WeatherDataRepository>(context).getGeoLocationDataByName(
              searchValue, null, null);
        },
        itemBuilder: (context, locationSuggestion) {
          return ListTile(
            leading: const Icon(Icons.pin_drop),
            title: Text(
              '${locationSuggestion.location}, ${locationSuggestion.countryCode}',
            ),
            subtitle: Text(
              'Lat: ${locationSuggestion.latitude}, Lon: ${locationSuggestion.longitude}',
            ),
          );
        },
        onSuggestionSelected: (selectedLocation) {
          BlocProvider.of<LocationSearchBloc>(context)
              .add(LocationSelectedEvent(selectedLocation: selectedLocation));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
