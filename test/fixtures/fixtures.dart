import 'dart:convert';
import 'dart:io';

String fixture(String name) =>
    File(testPath('/fixtures/$name')).readAsStringSync();

Map<String, dynamic> jsonFixture(String name) {
  final fixtureString = fixture(name);
  return jsonDecode(fixtureString);
}

List<dynamic> jsonArrayFixture(String name) {
  final fixtureString = fixture(name);
  return jsonDecode(fixtureString);
}

String testPath(String relativePath) {
  // Fix vscode test path
  final current = Directory.current;
  final path =
      current.path.endsWith('/test') ? current.path : '${current.path}/test';

  return '$path/$relativePath';
}
