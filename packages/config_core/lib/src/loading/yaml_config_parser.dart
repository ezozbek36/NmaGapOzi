import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import 'config_parser.dart';

class YamlConfigParser implements ConfigParser {
  static final YamlWriter _writer = YamlWriter();

  @override
  Map<String, dynamic> parse(String content) {
    final parsed = loadYaml(content);
    final converted = _convertNode(parsed);
    if (converted is Map<String, dynamic>) {
      return converted;
    }
    throw const FormatException('Top-level config must be a map');
  }

  @override
  String stringify(Map<String, dynamic> config) {
    final yaml = _writer.write(config);
    return yaml.endsWith('\n') ? yaml : '$yaml\n';
  }

  @override
  bool supportsPath(String path) {
    return path.endsWith('.yaml') || path.endsWith('.yml');
  }

  dynamic _convertNode(dynamic node) {
    if (node is YamlMap) {
      return node.map((k, v) => MapEntry(k.toString(), _convertNode(v)));
    }
    if (node is YamlList) {
      return node.map(_convertNode).toList();
    }
    if (node is Map) {
      return node.map((k, v) => MapEntry(k.toString(), _convertNode(v)));
    }
    if (node is List) {
      return node.map(_convertNode).toList();
    }
    return node;
  }
}
