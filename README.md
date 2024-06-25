This is a simple project created as a technical test for a previous job.
The task was to display details of a product, with the ability to add it to a basket.
Since there was no API provided, this was mocked in the implementation.

## Prerequisites ✅

This project requires Flutter 3.22.0 or higher, and Dart 3.4.0 or higher.

---

## FVM

The project uses [FVM](https://fvm.app/) for version management. To install the correct Flutter version for the project, just run this command in the project root:

```bash
$ fvm install
```

---

## Getting Started 🚀

To run the app either use the launch configuration in VSCode/Android Studio or use the following command:

```sh
$ fvm flutter run --target lib/main.dart
```
---

## Code Generation 🏗️

This project relies on generated code. Generators are provided by various packages and executed using `build_runner`. You can run the generators using this command:

```sh
$ fvm flutter pub run build_runner build --delete-conflicting-outputs
```

There is also a `watch` command which will run continuously and update generated code whenever a source code file is changed.

---