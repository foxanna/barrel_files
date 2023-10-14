import 'package:barrel_files/src/individual_barrel_files/generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder individualBarrelFilesBuilder(BuilderOptions options) => LibraryBuilder(
      const IndividualBarrelFilesGenerator(),
      generatedExtension: '.barrel',
      options: options,
    );
