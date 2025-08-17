import 'package:barrel_files/src/individual_barrel_files/builder_factory.dart';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  group('individualBarrelFilesBuilder :: no outputs', () {
    test('Empty inputs produce no output', () async {
      const inputFileName1 = '$_testPackageName|lib/empty_1.dart';
      const inputFileContent1 = '';

      const inputFileName2 = '$_testPackageName|lib/src/empty_2.dart';
      const inputFileContent2 = '';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
      };

      const expectedOutputs = <String, String>{};

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });

    test('Inputs with no annotation produce no output', () async {
      const inputFileName1 = '$_testPackageName|lib/empty_1.dart';
      const inputFileContent1 = '''
class Example {}
''';

      const inputFileName2 = '$_testPackageName|lib/src/empty_2.dart';
      const inputFileContent2 = '''
const i = 0;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
      };

      const expectedOutputs = <String, String>{};

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });
  });

  group('individualBarrelFilesBuilder :: valid outputs', () {
    test('Inputs with a single annotated element '
        'produce a single export directive '
        'with a single exposed element', () async {
      const inputFileName1 = '$_testPackageName|lib/test_1.dart';
      const inputFileContent1 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}
''';

      const expectedOutputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const expectedOutputFileContent1 = '''$_header
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
''';

      const inputFileName2 = '$_testPackageName|lib/test_2.dart';
      const inputFileContent2 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
const exampleGlobalConst = 0;
''';

      const expectedOutputFileName2 = '$_testPackageName|lib/test_2.barrel';
      const expectedOutputFileContent2 = '''$_header
export 'package:$_testPackageName/test_2.dart' show exampleGlobalConst;
''';

      const inputFileName3 = '$_testPackageName|lib/test_3.dart';
      const inputFileContent3 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
enum ExampleEnum {one, two, three} 
''';

      const expectedOutputFileName3 = '$_testPackageName|lib/test_3.barrel';
      const expectedOutputFileContent3 = '''$_header
export 'package:$_testPackageName/test_3.dart' show ExampleEnum;
''';

      const inputFileName4 = '$_testPackageName|lib/test_4.dart';
      const inputFileContent4 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
String exampleFunction() => 'example'; 
''';

      const expectedOutputFileName4 = '$_testPackageName|lib/test_4.barrel';
      const expectedOutputFileContent4 = '''$_header
export 'package:$_testPackageName/test_4.dart' show exampleFunction;
''';

      const inputFileName5 = '$_testPackageName|lib/test_5.dart';
      const inputFileContent5 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
typedef ExampleTypeDef = void Function(int i);
''';

      const expectedOutputFileName5 = '$_testPackageName|lib/test_5.barrel';
      const expectedOutputFileContent5 = '''$_header
export 'package:$_testPackageName/test_5.dart' show ExampleTypeDef;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
        inputFileName3: inputFileContent3,
        inputFileName4: inputFileContent4,
        inputFileName5: inputFileContent5,
      };

      const expectedOutputs = {
        expectedOutputFileName1: expectedOutputFileContent1,
        expectedOutputFileName2: expectedOutputFileContent2,
        expectedOutputFileName3: expectedOutputFileContent3,
        expectedOutputFileName4: expectedOutputFileContent4,
        expectedOutputFileName5: expectedOutputFileContent5,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });

    test('Inputs with a multiple annotated elements '
        'produce a single export directive with '
        'all elements exposed and sorted alphabetically', () async {
      const inputFileName1 = '$_testPackageName|lib/test_1.dart';
      const inputFileContent1 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass1 {}

@includeInBarrelFile
class ExampleClass2 {}
''';

      const expectedOutputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const expectedOutputFileContent1 = '''$_header
export 'package:$_testPackageName/test_1.dart' show ExampleClass1, ExampleClass2;
''';

      const inputFileName2 = '$_testPackageName|lib/test_2.dart';
      const inputFileContent2 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass2 {}

@includeInBarrelFile
class ExampleClass1 {}
''';

      const expectedOutputFileName2 = '$_testPackageName|lib/test_2.barrel';
      const expectedOutputFileContent2 = '''$_header
export 'package:$_testPackageName/test_2.dart' show ExampleClass1, ExampleClass2;
''';

      const inputFileName3 = '$_testPackageName|lib/test_3.dart';
      const inputFileContent3 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
String exampleFunction() => 'example'; 

@includeInBarrelFile
const exampleGlobalConst = 0;

@includeInBarrelFile
enum ExampleEnum {one, two, three}
''';

      const expectedOutputFileName3 = '$_testPackageName|lib/test_3.barrel';
      const expectedOutputFileContent3 = '''$_header
export 'package:$_testPackageName/test_3.dart'
    show ExampleEnum, exampleFunction, exampleGlobalConst;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
        inputFileName3: inputFileContent3,
      };

      const expectedOutputs = {
        expectedOutputFileName1: expectedOutputFileContent1,
        expectedOutputFileName2: expectedOutputFileContent2,
        expectedOutputFileName3: expectedOutputFileContent3,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });

    test(
      'Inputs with a mix of multiple annotated elements and non-annotated elements '
      'produce a single export directive with '
      'only annotated elements exposed and sorted alphabetically',
      () async {
        const inputFileName1 = '$_testPackageName|lib/test_1.dart';
        const inputFileContent1 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass2 {}

class ExampleClass3 {}

@includeInBarrelFile
class ExampleClass1 {}
''';

        const expectedOutputFileName1 = '$_testPackageName|lib/test_1.barrel';
        const expectedOutputFileContent1 = '''$_header
export 'package:$_testPackageName/test_1.dart' show ExampleClass1, ExampleClass2;
''';

        const inputFileName2 = '$_testPackageName|lib/test_2.dart';
        const inputFileContent2 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
String exampleFunction() => 'example'; 

const exampleGlobalConst = 0;

@includeInBarrelFile
enum ExampleEnum {one, two, three}

extension on ExampleEnum {
    int get exampleMethod => exampleGlobalConst;
}
''';

        const expectedOutputFileName2 = '$_testPackageName|lib/test_2.barrel';
        const expectedOutputFileContent2 = '''$_header
export 'package:$_testPackageName/test_2.dart' show ExampleEnum, exampleFunction;
''';

        const inputs = {
          inputFileName1: inputFileContent1,
          inputFileName2: inputFileContent2,
        };

        const expectedOutputs = {
          expectedOutputFileName1: expectedOutputFileContent1,
          expectedOutputFileName2: expectedOutputFileContent2,
        };

        await _createAndTestBuilder(
          inputs: inputs,
          expectedOutputs: expectedOutputs,
        );
      },
    );

    test('Input with a "part" file with multiple annotated elements '
        'produce a single export directive with '
        'all elements exposed and sorted alphabetically', () async {
      const inputFileName1 = '$_testPackageName|lib/test_1.dart';
      const inputFileContent1 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

part 'test_1.part.dart';

@includeInBarrelFile
class ExampleClass1 {}
''';

      const inputFileName2 = '$_testPackageName|lib/test_1.part.dart';
      const inputFileContent2 = '''
part of 'test_1.dart';

@includeInBarrelFile
class ExampleClass2 {}
''';

      const expectedOutputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const expectedOutputFileContent1 = '''$_header
export 'package:$_testPackageName/test_1.dart' show ExampleClass1, ExampleClass2;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
      };

      const expectedOutputs = {
        expectedOutputFileName1: expectedOutputFileContent1,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });

    test('Inputs with various paths produce corresponding outputs', () async {
      const inputFileName1 = '$_testPackageName|lib/test_1.dart';
      const inputFileContent1 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}
''';

      const expectedOutputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const expectedOutputFileContent1 = '''$_header
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
''';

      const inputFileName2 = '$_testPackageName|lib/src/test_2.dart';
      const inputFileContent2 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}
''';

      const expectedOutputFileName2 = '$_testPackageName|lib/src/test_2.barrel';
      const expectedOutputFileContent2 = '''$_header
export 'package:$_testPackageName/src/test_2.dart' show ExampleClass;
''';

      const inputFileName3 = '$_testPackageName|lib/src/example/test_3.dart';
      const inputFileContent3 = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

@includeInBarrelFile
class ExampleClass {}
''';

      const expectedOutputFileName3 =
          '$_testPackageName|lib/src/example/test_3.barrel';
      const expectedOutputFileContent3 = '''$_header
export 'package:$_testPackageName/src/example/test_3.dart' show ExampleClass;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
        inputFileName3: inputFileContent3,
      };

      const expectedOutputs = {
        expectedOutputFileName1: expectedOutputFileContent1,
        expectedOutputFileName2: expectedOutputFileContent2,
        expectedOutputFileName3: expectedOutputFileContent3,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
      );
    });
  });

  group('individualBarrelFilesBuilder :: invalid inputs', () {
    test('Unnamed annotated elements cause exception', () async {
      const inputFileName = '$_testPackageName|lib/test.dart';
      const inputFileContent = '''
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

class Example {}

@includeInBarrelFile
extension on Example {
  String get exampleGetter => '42';
}
''';

      const inputs = {inputFileName: inputFileContent};

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: <String, String>{},
        expectedError:
            '`@includeInBarrelFile` can only be used on elements with a name.\n'
            'Cause: extension on Example',
      );
    });
  });
}

Future<void> _createAndTestBuilder({
  required Map<String, String> inputs,
  Map<String, String> expectedOutputs = const {},
  String? expectedError,
}) async {
  final builder = individualBarrelFilesBuilder(
    const BuilderOptions(<String, dynamic>{}),
  );

  final readerWriter = TestReaderWriter(rootPackage: _testPackageName);
  await readerWriter.testing.loadIsolateSources();

  final logs = <LogRecord>[];

  await testBuilder(
    builder,
    inputs,
    outputs: expectedOutputs,
    readerWriter: readerWriter,
    onLog: (log) => logs.add(log),
  );

  if (expectedError != null) {
    expect(
      logs,
      anyElement(
        predicate<LogRecord>(
          (log) =>
              log.level == Level.SEVERE && log.message.contains(expectedError),
        ),
      ),
    );
  }
}

const _testPackageName = 'test_package';

const _header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: Instance of 'IndividualBarrelFilesGenerator'
// **************************************************************************
''';
