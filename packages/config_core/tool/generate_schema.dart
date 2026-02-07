import 'dart:convert';
import 'dart:io';

import 'package:config_core/src/schema/app_config.dart';

Future<void> main(List<String> args) async {
  final outputPath = args.isNotEmpty ? args.first : 'app_config.schema.json';
  final outputFile = File(outputPath);

  await outputFile.parent.create(recursive: true);

  final encoder = const JsonEncoder.withIndent('  ');
  final schemaJson = '${encoder.convert(appConfigJsonSchema)}\n';

  await outputFile.writeAsString(schemaJson);

  stdout.writeln('Wrote schema to ${outputFile.path}');
}
