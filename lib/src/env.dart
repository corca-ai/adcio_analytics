import 'package:adcio_analytics/src/errors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Env {
  Env._();

  static bool _isInitialized = false;
  static final Map<String, String> _envMap = {};

  /// A copy of variables loaded at runtime from a file + any entries from mergeWith when loaded.
  static Map<String, String> get env {
    if (!_isInitialized) {
      throw NotInitializedError();
    }
    return _envMap;
  }

  static bool get isInitialized => _isInitialized;

  /// Clear [env]
  static void clean() => _envMap.clear();

  static String get(String name, {String? fallback}) {
    final value = maybeGet(name, fallback: fallback);
    if (value == null) {
      throw Exception(
          '$name variable not found. A non-null fallback is required for missing entries');
    }
    return value;
  }

  static String? maybeGet(String name, {String? fallback}) =>
      env[name] ?? fallback;

  /// Loads environment variables from the env file into a map
  /// Merge with any entries defined in [mergeWith]
  static Future<void> load(
      {String fileName = '.env',
      Map<String, String> mergeWith = const {},
      bool isOptional = false}) async {
    clean();
    List<String> linesFromFile;
    try {
      linesFromFile = await _getEntriesFromFile(fileName);
    } on FileNotFoundError {
      if (isOptional) {
        linesFromFile = [];
      } else {
        rethrow;
      }
    }

    final linesFromMergeWith = mergeWith.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .toList();
    final allLines = linesFromMergeWith..addAll(linesFromFile);
    final envEntries = _Parser.parse(allLines);
    _envMap.addAll(envEntries);
    _isInitialized = true;
  }

  static void testLoad(
      {String fileInput = '', Map<String, String> mergeWith = const {}}) {
    clean();
    final linesFromFile = fileInput.split('\n');
    final linesFromMergeWith = mergeWith.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .toList();
    final allLines = linesFromMergeWith..addAll(linesFromFile);
    final envEntries = _Parser.parse(allLines);
    _envMap.addAll(envEntries);
    _isInitialized = true;
  }

  /// True if all supplied variables have nonempty value; false otherwise.
  /// Differs from [containsKey](dart:core) by excluding null values.
  /// Note [load] should be called first.
  static bool isEveryDefined(Iterable<String> vars) =>
      vars.every((k) => _envMap[k]?.isNotEmpty ?? false);

  static Future<List<String>> _getEntriesFromFile(String filename) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      var envString = await rootBundle.loadString(filename);
      if (envString.isEmpty) {
        throw EmptyEnvFileError();
      }
      return envString.split('\n');
    } on FlutterError {
      throw FileNotFoundError();
    }
  }
}

class _Parser {
  static const _singleQuot = "'";
  static final _leadingExport = RegExp(r'''^ *export ?''');
  static final _comment = RegExp(r'''#[^'"]*$''');
  static final _commentWithQuotes = RegExp(r'''#.*$''');
  static final _surroundQuotes = RegExp(r'''^(["'])(.*?[^\\])\1''');
  static final _bashVar = RegExp(r'''(\\)?(\$)(?:{)?([a-zA-Z_][\w]*)+(?:})?''');

  const _Parser._();

  /// Creates a [Map](dart:core).
  /// Duplicate keys are silently discarded.
  static Map<String, String> parse(Iterable<String> lines) {
    var out = <String, String>{};
    for (var line in lines) {
      var kv = parseOne(line, env: out);
      if (kv.isEmpty) continue;
      out.putIfAbsent(kv.keys.single, () => kv.values.single);
    }
    return out;
  }

  /// Parses a single line into a key-value pair.
  static Map<String, String> parseOne(String line,
      {Map<String, String> env = const {}}) {
    var stripped = strip(line);
    if (!_isValid(stripped)) return {};

    var idx = stripped.indexOf('=');
    var lhs = stripped.substring(0, idx);
    var k = swallow(lhs);
    if (k.isEmpty) return {};

    var rhs = stripped.substring(idx + 1, stripped.length).trim();
    var quotChar = surroundingQuote(rhs);
    var v = unquote(rhs);
    if (quotChar == _singleQuot) {
      v = v.replaceAll("\\'", "'");
      return {k: v};
    }
    if (quotChar == '"') {
      v = v.replaceAll('\\"', '"').replaceAll('\\n', '\n');
    }
    final interpolatedValue = interpolate(v, env).replaceAll("\\\$", "\$");
    return {k: interpolatedValue};
  }

  /// Substitutes $bash_vars in [val] with values from [env].
  static interpolate(String val, Map<String, String?> env) =>
      val.replaceAllMapped(_bashVar, (m) {
        if ((m.group(1) ?? "") == "\\") {
          return m.input.substring(m.start, m.end);
        } else {
          var k = m.group(3)!;
          if (!_has(env, k)) return '';
          return env[k]!;
        }
      });

  /// If [val] is wrapped in single or double quotes, returns the quote character.
  /// Otherwise, returns the empty string.

  static String surroundingQuote(String val) {
    if (!_surroundQuotes.hasMatch(val)) return '';
    return _surroundQuotes.firstMatch(val)!.group(1)!;
  }

  /// Removes quotes (single or double) surrounding a value.
  static String unquote(String val) {
    if (!_surroundQuotes.hasMatch(val)) {
      return strip(val, includeQuotes: true).trim();
    }
    return _surroundQuotes.firstMatch(val)!.group(2)!;
  }

  /// Strips comments (trailing or whole-line).
  static String strip(String line, {bool includeQuotes = false}) =>
      line.replaceAll(includeQuotes ? _commentWithQuotes : _comment, '').trim();

  /// Omits 'export' keyword.
  static String swallow(String line) =>
      line.replaceAll(_leadingExport, '').trim();

  static bool _isValid(String s) => s.isNotEmpty && s.contains('=');

  /// [ null ] is a valid value in a Dart map, but the env var representation is empty string, not the string 'null'
  static bool _has(Map<String, String?> map, String key) =>
      map.containsKey(key) && map[key] != null;
}
