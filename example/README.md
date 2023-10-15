1. Add dependency:

```yaml
# pubspec.yaml

name: example_package

dependencies:
  barrel_files_annotation:
  ...

dev_dependencies:
  barrel_files: 
  build_runner:
  ...
```

2. Annotate public top elements:

```dart
// lib/src/example_input.dart

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

3. Run code generation:

```
dart run build_runner build --delete-conflicting-outputs
```

4. Have the barrel file generated:

```dart
// lib/example_package.dart

// GENERATED CODE - DO NOT MODIFY BY HAND

export 'package:example_package/src/example_input.dart'
    show
        ExampleClass,
        ExampleEnum,
        ExampleTypeDef,
        exampleFunction,
        exampleGlobalConst;
```
