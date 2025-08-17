import 'package:barrel_files/src/package_barrel_files/builder_factory.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

void main() {
  late FileSystem testFileSystem;

  setUp(() {
    testFileSystem = MemoryFileSystem.test();
    testFileSystem.file('pubspec.yaml')
      ..createSync()
      ..writeAsStringSync(_testPubspecFile);
  });

  group('barrelFilesBuilder :: no outputs', () {
    test('Empty inputs produce no output', () async {
      const inputs = <String, String>{};
      const expectedOutputs = <String, String>{};

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
        fileSystem: testFileSystem,
      );
    });
  });

  group('barrelFilesBuilder :: valid outputs', () {
    test('export directives from all all .barrel files '
        'are composed to a single .dart file', () async {
      const inputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const inputFileContent1 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
''';

      const inputFileName2 = '$_testPackageName|lib/test_2.barrel';
      const inputFileContent2 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_2.dart' show exampleGlobalConst;
''';

      const inputFileName3 = '$_testPackageName|lib/test_3.barrel';
      const inputFileContent3 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_3.dart' show ExampleEnum;
''';

      const inputFileName4 = '$_testPackageName|lib/test_4.barrel';
      const inputFileContent4 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_4.dart' show exampleFunction;
''';

      const inputFileName5 = '$_testPackageName|lib/test_5.barrel';
      const inputFileContent5 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_5.dart' show ExampleTypeDef;
''';

      const expectedOutputFileName =
          '$_testPackageName|lib/$_testPackageName.dart';
      const expectedOutputFileContent = '''$_packageBarrelFileHeader
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
export 'package:$_testPackageName/test_2.dart' show exampleGlobalConst;
export 'package:$_testPackageName/test_3.dart' show ExampleEnum;
export 'package:$_testPackageName/test_4.dart' show exampleFunction;
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
        expectedOutputFileName: expectedOutputFileContent,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
        fileSystem: testFileSystem,
      );
    });

    test('barrel file name can be configured in BuilderOptions', () async {
      const expectedFileName = 'custom_barrel_file_name.dart';
      const builderOptionsConfig = {'barrel_file_name': expectedFileName};

      const inputFileName1 = '$_testPackageName|lib/test_1.barrel';
      const inputFileContent1 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
''';

      const inputFileName2 = '$_testPackageName|lib/test_2.barrel';
      const inputFileContent2 = '''$_individualBarrelFileHeader
export 'package:$_testPackageName/test_2.dart' show exampleGlobalConst;
''';

      const expectedOutputFileName = '$_testPackageName|lib/$expectedFileName';
      const expectedOutputFileContent = '''$_packageBarrelFileHeader
export 'package:$_testPackageName/test_1.dart' show ExampleClass;
export 'package:$_testPackageName/test_2.dart' show exampleGlobalConst;
''';

      const inputs = {
        inputFileName1: inputFileContent1,
        inputFileName2: inputFileContent2,
      };

      const expectedOutputs = {
        expectedOutputFileName: expectedOutputFileContent,
      };

      await _createAndTestBuilder(
        inputs: inputs,
        expectedOutputs: expectedOutputs,
        options: builderOptionsConfig,
        fileSystem: testFileSystem,
      );
    });
  });
}

Future<void> _createAndTestBuilder({
  required Map<String, String> inputs,
  Map<String, String> expectedOutputs = const {},
  Map<String, dynamic> options = const {},
  required FileSystem fileSystem,
}) async {
  final builder = barrelFilesBuilder(
    BuilderOptions(options),
    fileSystem,
  );

  await testBuilder(
    builder,
    inputs,
    outputs: expectedOutputs,
  );
}

const _testPackageName = 'test_package';

const _individualBarrelFileHeader = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: Instance of 'IndividualBarrelFilesGenerator'
// **************************************************************************
''';

const _packageBarrelFileHeader = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
''';

const _testPubspecFile = '''
name: $_testPackageName

version: 0.0.0+1

environment:
  sdk: ^3.0.0
''';
