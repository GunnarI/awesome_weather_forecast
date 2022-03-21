class GeoLocation {
  final String location;
  final String countryCode;
  final double latitude;
  final double longitude;
  final Map<String, dynamic>? localNames;
  final String? state;

  const GeoLocation({
    required this.location,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    this.localNames=const <String, dynamic>{},
    this.state,
  });

  @override
  String toString() {
    return '$location, $countryCode,${state == null ? '' : ' $state,'} $latitude, $longitude';
  }
}
