abstract class Migration {
  int get fromVersion;
  int get toVersion;
  Map<String, dynamic> migrate(Map<String, dynamic> config);
}
