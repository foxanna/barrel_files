import 'dart:async';

import 'package:analyzer/dart/element/element2.dart';
import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:source_gen/source_gen.dart';

class IndividualBarrelFilesGenerator implements Generator {
  const IndividualBarrelFilesGenerator();

  static const _annotation = TypeChecker.typeNamed(
    IncludeInBarrelFile,
    inPackage: 'barrel_files_annotation',
  );

  @override
  FutureOr<String?> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) {
    final annotatedTopLevelElements = library
        .annotatedWith(_annotation)
        .toList();

    final elementsNames = annotatedTopLevelElements
        .map(
          (annotatedElement) => annotatedElement.element.name3.isNotNullOrEmpty
              ? annotatedElement.element.name3!
              : throw UnnamedGenerationSourceError(annotatedElement.element),
        )
        .toList();

    final export = _composeOutput(buildStep.inputId, elementsNames);
    return export;
  }
}

String? _composeOutput(AssetId inputId, List<String> names) {
  if (names.isEmpty) {
    return null;
  }

  final export = _composeExport(
    exportedUri: inputId.uri,
    exportedNames: names,
  );
  return export;
}

String _composeExport({
  required Uri exportedUri,
  required List<String> exportedNames,
}) {
  final directive = Directive.export(
    exportedUri.toString(),
    show: exportedNames.sorted(),
  );
  final library = Library(
    (builder) => builder.directives.add(directive),
  );

  final source = library.accept(DartEmitter()).toString();
  return DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  ).format(source);
}

class UnnamedGenerationSourceError extends InvalidGenerationSourceError {
  UnnamedGenerationSourceError(Element2 element)
      : super(
          "`@includeInBarrelFile` can only be used on elements with a name.",
          element: element,
        );
}
