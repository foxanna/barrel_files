import 'package:barrel_files/src/package_barrel_files/builder.dart';
import 'package:build/build.dart';
import 'package:file/file.dart';

Builder barrelFilesBuilder(
  BuilderOptions options, [
  FileSystem? fileSystem,
]) =>
    PackageBarrelFilesBuilder(
      options.config,
      fileSystem,
    );
