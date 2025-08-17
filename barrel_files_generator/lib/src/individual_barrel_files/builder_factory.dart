import 'package:barrel_files/src/individual_barrel_files/generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// A builder to generate individual barrel files to be later combined
/// into a single package barrel file by [barrelFilesBuilder]
Builder individualBarrelFilesBuilder(BuilderOptions options) => LibraryBuilder(
  const IndividualBarrelFilesGenerator(),
  generatedExtension: '.barrel',
  options: options,
  formatOutput: (code, _) => code,
);
