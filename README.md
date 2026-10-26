# Cerdas Yuk!

A responsive Flutter multiple-choice quiz app with local questions, player
scoring, answer explanations, light/dark themes, and a locally bundled Nunito
font.

## Run the app

```sh
flutter pub get
flutter run
```

## Run tests

```sh
flutter test
```

Quiz answers and the current question are held in a shared `QuizSession`, so
progress remains available when navigating between the home and quiz screens
or when the device is rotated.
