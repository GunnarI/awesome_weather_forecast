# Awesome Weather Forecast

Yet another weather app... but this one is the most awesome and it is open source!

**Table of Contents**
- [Awesome Weather Forecast](#awesome-weather-forecast)
  - [Description](#description)
  - [Getting started](#getting-started)
  - [Contribution guidelines](#contribution-guidelines)
    - [Reporting bugs](#reporting-bugs)
    - [Code contribution](#code-contribution)
      - [Styling](#styling)
      - [Architecture](#architecture)
  - [Dependencies](#dependencies)
    - [cupertino_icons](#cupertino_icons)
    - [http](#http)
    - [flutter_bloc](#flutter_bloc)
    - [intl](#intl)
    - [flutter_typeahead](#flutter_typeahead)
    - [drift](#drift)
  - [Known issues](#known-issues)

## Description
This weather app uses the free version of the [OpenWeather API](https://openweathermap.org/api) to display weather forecast for the next few days in a selected location.

## Getting started
The app depends on some generated code using build_runner. To compile and run using `flutter run`, you first need to run build_runner:
```bash
# Run build_runner once to generate the necessary code
flutter pub run build_runner build

# Run flutter to run the app on attached device
flutter run -d <your-device-id>
```

## Contribution guidelines
### Reporting bugs
Please read the documentation before reporting bugs.
Any bug report submitted should be structurally build with clear description including how to reproduce and providing code snippets or screenshots when it helps describe the bug.

### Code contribution
It is easy to contribute. Simply fork the project, do whichever changes on the fork, you think might help the project. After testing locally and making sure you are happy with your addition to the project, then create a pull request. The PR will then be tested and if approved, it will be merged into main.

#### Styling
Clear styling guidelines are still missing but please don't go too crazy. Try to write nice, clean, and understandable code, otherwise your PR will be rejected and you will have the shame walk... you know the one... from GoT... we wouldn't want that would we.

#### Architecture
Awesome Weather Forecast is developed using the BLoC design pattern. For that, the flutter_bloc package is used. Please refer to the documentation [here](https://bloclibrary.dev/#/).

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

## Known issues
* There are a bunch of unresolved TODOs which need to be handled to improve the overall quality of the code as well as the UI/UX of the app.

* The hourly weather forecast which is shown in the detailed view is only provided for the next 48hr by the API. It is thus not possible to see the details screen for more than 2-3 items in the list.

  * One possible solution is to use the https://openweathermap.org/forecast5 API to get the forecast for 3hr intervals for the next 5 days, leaving only a couple of items at the bottom of the list without a details screen.

* The loading of weather data on the home screen takes a while. This is because both the weather data for the listview on home screen as well as the data for the details list are being fetched and cached before anything is displayed. However, the fetching of the details data as well as the caching of everything could happen parallel to the presentation on the home screen. It is just important that it is done before navigating to the details screen.

* Error handling needs to be improved. In some places the errors are not caught before reaching the presentation layer. One such example is the location search field. If there is an error in fetching the options list, the error will be displayed directly instead of the list.

* Selected locations are cached forever. This should not cause too many problems and this could be used to create a sort of "favorites locations" in the future where selected locations would automatically be added to favorites and could easily be accessed from there or deleted from the list if desired.

* The project is completely missing a test suite.

* The project does not have clear styling guidelines
