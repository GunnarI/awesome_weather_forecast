import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/repositories/weather_data_repository.dart';
import '/models/database/local_database.dart';
import 'bloc/location_search_bloc.dart';

class LocationSearchPage extends StatelessWidget {
  static const routeName = '/location-search';

  const LocationSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search location'),
      ),
      body: TypeAheadField<GeoLocation>(
        keepSuggestionsOnLoading: false,
        suggestionsCallback: (searchValue) async {
          if (searchValue.isEmpty) return [];
          // TODO: Make sure it is also possible to search by other params (e.g. lat, lon, country)
          // TODO: Move below logic into the bloc and make sure errors in search are handled.
          var suggestionList = await RepositoryProvider.of<WeatherDataRepository>(context).getGeoLocationDataByName(
              searchValue, null, null);
          BlocProvider.of<LocationSearchBloc>(context).add(OptionsLoadingEvent(locationOptions: suggestionList));
          return suggestionList;
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
