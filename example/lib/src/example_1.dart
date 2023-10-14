import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}

@includeInBarrelFile
const exampleGlobalConst = 0;

@includeInBarrelFile
enum ExampleEnum { one, two, three }

@includeInBarrelFile
String exampleFunction() => 'example';

@includeInBarrelFile
typedef ExampleTypeDef = void Function(int i);
