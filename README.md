# Cerdas Yuk!

A responsive Flutter quiz app with nine quiz collections across general
knowledge, fun facts, and cryptography basics. Browse by category, search quiz
titles, track your score, review explanations, and switch between light and
dark themes. The app includes a locally bundled Nunito font.

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

The cryptography collection covers introductory concepts such as encryption,
public and private keys, classical ciphers, hashes, digital signatures, and
HTTPS.
