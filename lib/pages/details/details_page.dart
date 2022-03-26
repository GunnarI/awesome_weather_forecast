import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/pages/home/bloc/home_bloc.dart';
import 'bloc/details_bloc.dart';

class DetailsPage extends StatelessWidget {
  static const routeName = '/details';

  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailsBloc>(context).add(LoadWeatherHoursEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(BlocProvider.of<HomeBloc>(context).repository.selectedGeoLocation!.location),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          if (state is LoadingWeatherHoursState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FailedToLoadWeatherHoursState) {
            return const Center(
              child: Text('Something went wrong in fetching data... please try again later!'),
            );
          } else if (state is LoadedWeatherHoursState) {
            return Center(child: Text(state.weatherHours.first.weatherGroupDescription),);
          } else {
            return const Center(
              child: Text('Something went wrong... please try again later!'),
            );
          }
        },
      ),
    );
  }
}
