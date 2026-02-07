abstract class ConfigParser {
  Map<String, dynamic> parse(String content);

  String stringify(Map<String, dynamic> config);

  bool supportsPath(String path);
}
