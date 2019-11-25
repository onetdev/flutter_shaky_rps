# Shaky RPS

A simple game for rock-paper-scissors but with the user having to shake the phone in order to
get a random roll. The framework used for the project is [Flutter](https://flutter.io) which 
is a cross-platform (iOS & Android) framework.

The project contains a custom shake detection algorithm for better and smoother experience.

## Resources

- [Trello board](https://trello.com/b/F2jXS39r/shaky-rps)

## Installation

1) Get Flutter: https://flutter.dev/docs/get-started/install
2) Get Android Studio: https://developer.android.com/studio
3) Run `flutter doctor` and see what is missing for starting working on this project.
4) Create `android/key.properties` file pointing to the corresponding jks file. [More info](https://flutter.dev/docs/deployment/android)

## Release

1) Increase `version`in `pubspec.yml` file.
2) Run `flutter build appbundle`
