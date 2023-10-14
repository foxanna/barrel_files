# barrel_files [![pub package](https://img.shields.io/pub/v/barrel_files.svg)](https://pub.dartlang.org/packages/barrel_files)

## Motivation

## Usage

### Add the dependency

Add `barrel_files_annotation` to `dependencies` and `barrel_files` to `dev_dependencies` section of the `pubspec.yaml` file:

```yaml
dependencies:
  barrel_files_annotation:
  ...

dev_dependencies:
  barrel_files: 
  build_runner:
  ...
```

### Annotate public elements

Annotate classes, enums, global constants and any other top level elements that are not private to the package with `@includeInBarrelFile`:

```dart
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}

@includeInBarrelFile
const exampleGlobalConst = 0;

@includeInBarrelFile
enum ExampleEnum {one, two, three}

@includeInBarrelFile
String exampleFunction() => 'example';

@includeInBarrelFile
typedef ExampleTypeDef = void Function(int i);
```

### Generate barrel file

To run the code generator, execute the following command:

```
dart run build_runner build --delete-conflicting-outputs
```

A new `.dart` file will be created under the `/lib` folder. If the example usage of `@includeInBarrelFile` annotation above is located in the `lib/src/example_input.dart` file of the `example_package` package, the output will be:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

export 'package:example_package/src/example_input.dart'
    show
        ExampleClass,
        ExampleEnum,
        ExampleTypeDef,
        exampleFunction,
        exampleGlobalConst;
```

By default, barre; file name will match the package name, `example_package` in the example above.

To customize the generated file name (and possibly location), create or modify the `build.yaml` file located next to the `pubspec.yaml` file:

```yaml
targets:
  $default:
    builders:
      barrel_files|barrel_files:
        options:
          barrel_file_name: "custom_example.dart"
```

This setup will result in `lib/custom_example.dart` file  being created.

For now, `barrel_files` only supports a single barrel file generation.
