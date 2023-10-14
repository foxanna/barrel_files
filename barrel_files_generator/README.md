[![pub package](https://img.shields.io/pub/v/barrel_files.svg)](https://pub.dartlang.org/packages/barrel_files)

Generate barrel files for Dart and Flutter packages with `build_runner` based on code annotations.

## Motivation

### Barrel files

In Dart, visibility of a class, global variable or any other top-level element can be limited to a single library (single `.dart` file or a group of `.dart` files united with `part` and `part of` directives) by simply naming those elements with `_` prefix. This way, information about code visibility in as close to the code itself as possible.

However, there is no similar mechanism to scope code elements visibility to a package where they are located, keeping them accessible to all the rest of the code in the same package, but making them inaccessible from outside. To reach the same effect, when creating a Dart or Flutter package, it is common to put all `.dart` files under the `/lib/src` folder and create a new `.dart` file under the `/lib` folder (usually named after the package), that contains `export` directives for files and Dart code elements that should be exposed from that package. These files are called "barrel files".

This approach helps with encapsulation as users of these packages will get warnings if they import a file from the `/lib/src` folder instead of importing one of barrel files from the `/lib` folder. However, in this case the information about code visibility gets detached from the code itself and is controlled in a barrel file in a different location. 

### Generated barrel files

For packages that rely on code-generation with `build_runner`, it can be beneficial to use the `barrel_files` package to create barrel files based on annotations placed directly above code elements that should be visible outside those packages. 

A special annotation to mark public code provides information about code visibility right where it is needed - next to the code itself!

## Usage

### Add dependencies

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

By default, barrel file name matches the package name, `example_package` in the example above.

To customize the generated file name (and possibly location), create or modify the `build.yaml` file located next to the `pubspec.yaml` file:

```yaml
targets:
  $default:
    builders:
      barrel_files|barrel_files:
        options:
          barrel_file_name: "custom_example.dart"
```

This setup will result in `lib/custom_example.dart` barrel file  being created.

## Constraints

`barrel_files` supports only one barrel file generation.
