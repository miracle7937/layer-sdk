import 'dart:convert';
import 'dart:io';

/// Reads a file under supplied path synchronously and returns decoded json.
///
/// Throws if the file doesn't exist.
// TODO: check if we can import this layer in a web project
// if we use `dart:io` in the tests
Map<String, dynamic> loadJsonFile(String path) {
  final file = File(path);
  final data = file.readAsStringSync();
  return json.decode(data);
}
