class GeoLocation {
  final String location;
  final String countryCode;
  final double latitude;
  final double longitude;
  final List<String> localNames;
  final String? state;

  GeoLocation({
    required this.location,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    this.localNames=const <String>[],
    this.state,
  });
}
