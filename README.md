# awesome_weather_forecast

Yet another weather app... but this one is the most awesome and it is open source!

**Table of Contents**
- [awesome_weather_forecast](#awesome_weather_forecast)
  - [Getting started](#getting-started)
  - [Dependencies](#dependencies)
    - [cupertino_icons](#cupertino_icons)
    - [http](#http)
    - [flutter_bloc](#flutter_bloc)
    - [intl](#intl)
    - [flutter_typeahead](#flutter_typeahead)
    - [drift](#drift)

## Getting started
The app depends on some generated code using build_runner. To compile and run using `flutter run`, you first need to run build_runner:
```bash
# Run build_runner once to generate the necessary code
flutter pub run build_runner build

# Run flutter to run the app on attached device
flutter run -d <your-device-id>
```

## Dependencies
### cupertino_icons

### http
An official core package published by the Dart Team. Works well and is easy to use for any kind of http requests. Used here to communicate with the weather API used.

### flutter_bloc
A "Flutter Favorite" package on pub.dev. The architecture of the app uses the BLoC design pattern and the package enables that. The reason for using the BLoC design pattern is for separation of concern to keep the business logic from the presentation layer in a nice and maintainable way. Also, because Stokkur uses the BLoC pattern, I've learned.

### intl
A "Flutter Favorite" package on pub.dev. According to the publisher it "contains code to deal with internationalized/localized messages, date and number formatting and parsing, bi-directional text, and other internationalization issues".
Used here mainly for the date formatting but could be used for internationalization if that will be supported in the future.

### flutter_typeahead
A very nice edit text field which provides a suggestions list based on results from API in a nice and easy way. The package seems to be rather mature and works well for our simple purpose.

### drift
A "Flutter Favorite" on pub.dev. Provides a nice and easy way to store data model classes in local sql database. The following dependencies are also added as recommended by the _drift_ documentation.
* **sqlite3_flutter_libs**
* **path_provider**
* **path**
* **drift_dev** (as dev_dependency)
* **build_runner** (as dev_dependency)
