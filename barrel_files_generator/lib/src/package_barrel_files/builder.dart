import 'package:build/build.dart';
import 'package:dartx/dartx.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

class PackageBarrelFilesBuilder implements Builder {
  factory PackageBarrelFilesBuilder(
    Map<String, dynamic> config,
    FileSystem? fileSystem,
  ) => PackageBarrelFilesBuilder._(
    _getBarrelFilePath(config, fileSystem),
  );

  const PackageBarrelFilesBuilder._(this._barrelFilePath);

  final String _barrelFilePath;

  static const _barrelFileHeader = '// GENERATED CODE - DO NOT MODIFY BY HAND';

  @override
  Future<void> build(BuildStep buildStep) async {
    final individualBarrelFiles = Glob("**.barrel");
    final assets = await buildStep.findAssets(individualBarrelFiles).toList();
    final contents = await Future.wait(
      assets.map((assetId) => buildStep.readAsString(assetId)),
    );
    final truncatedContents =
        contents
            .map((content) => content.substring(content.indexOf('export')))
            .toList();
    final barrelFileContent =
        '$_barrelFileHeader\n\n'
        '${truncatedContents.sorted().join('')}';

    return buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      barrelFileContent,
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [_barrelFilePath],
  };

  static String _getBarrelFilePath(
    Map<String, dynamic> config,
    FileSystem? fileSystem,
  ) {
    final barrelFileNameFromConfig = (config['barrel_file_name'] as String?)
        ?.removeSuffix('.dart');
    final barrelFileName =
        barrelFileNameFromConfig ?? _getPackageName(fileSystem);
    final barrelFilePath = 'lib/$barrelFileName.dart';
    return barrelFilePath;
  }

  static String _getPackageName(FileSystem? priorityFileSystem) {
    final fileSystem = priorityFileSystem ?? const LocalFileSystem();
    final pubspecFile = fileSystem.file(Uri.file('pubspec.yaml'));
    final content = pubspecFile.readAsStringSync();
    final contentMap = loadYaml(content) as Map;
    final packageName = contentMap['name'] as String;
    return packageName;
  }
}
