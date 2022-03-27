import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/utils/utility.dart';
import '/repositories/weather_data_repository.dart';
import '/models/database/local_database.dart';
import 'bloc/location_search_bloc.dart';

enum SearchValueOptions {
  name,
  stateCode,
  countryCode,
  latitude,
  longitude,
}

class LocationSearchPage extends StatelessWidget {
  static const routeName = '/location-search';

  const LocationSearchPage({Key? key}) : super(key: key);

  Map<SearchValueOptions, dynamic> _searchValueParser(String searchValue) {
    var doublesInSearchValue = Utility.extractDoublesFromString(searchValue);

    // If the two first numbers found in the search value are valid latitude and longitude values,
    // respectively then we assume that is what the user is looking for. Otherwise, we look for name string.
    if (doublesInSearchValue.length > 1 &&
        Utility.isValidLatitude(doublesInSearchValue[0]) &&
        Utility.isValidLongitude(doublesInSearchValue[1])) {
      return {
        SearchValueOptions.latitude: doublesInSearchValue[0],
        SearchValueOptions.longitude: doublesInSearchValue[1]
      };
    } else {
      // TODO: Extract name, stateCode and countryCode from string and validate their format to use for the search
      return {SearchValueOptions.name: searchValue};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Search by city name or geo coordinates',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TypeAheadField<GeoLocation>(
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                    labelText: '(e.g. "Reykjavik" OR "64.12, -21.82")'),
              ),
              keepSuggestionsOnLoading: false,
              suggestionsCallback: (searchValue) async {
                if (searchValue.isEmpty) return [];
                // TODO: Move below logic into the bloc and make sure errors in search are handled.
                final parsedSearchValue = _searchValueParser(searchValue);
                late final List<GeoLocation> suggestionList;
                if (parsedSearchValue[SearchValueOptions.latitude] != null &&
                    parsedSearchValue[SearchValueOptions.longitude] != null) {
                  suggestionList =
                      await RepositoryProvider.of<WeatherDataRepository>(
                              context)
                          .getGeoLocationDataByLatLon(
                    parsedSearchValue[SearchValueOptions.latitude],
                    parsedSearchValue[SearchValueOptions.longitude],
                  );
                } else if (parsedSearchValue[SearchValueOptions.name] != null) {
                  suggestionList =
                      await RepositoryProvider.of<WeatherDataRepository>(
                              context)
                          .getGeoLocationDataByName(searchValue, null, null);
                } else {
                  suggestionList = [];
                }
                BlocProvider.of<LocationSearchBloc>(context)
                    .add(OptionsLoadingEvent(locationOptions: suggestionList));
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
                BlocProvider.of<LocationSearchBloc>(context).add(
                    LocationSelectedEvent(selectedLocation: selectedLocation));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
