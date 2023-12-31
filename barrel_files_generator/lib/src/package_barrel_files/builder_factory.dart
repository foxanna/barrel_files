import 'package:barrel_files/src/package_barrel_files/builder.dart';
import 'package:build/build.dart';
import 'package:file/file.dart';

/// A builder to generate the single package barrel file
/// from individual barrel files generated by [individualBarrelFilesBuilder]
Builder barrelFilesBuilder(BuilderOptions options, [FileSystem? fileSystem]) =>
    PackageBarrelFilesBuilder(options.config, fileSystem);
