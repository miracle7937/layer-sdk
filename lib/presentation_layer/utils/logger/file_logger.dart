import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/helpers.dart';

///This class used to keep logs to the file
class FileLogger {
  static late String _path_1;
  static late String _path_2;
  static late String _path;
  static late String _folderPath;
  static final _fileSize = DataSize.mega(2).realSize;
  static late File _file;
  static int _cumulativeSize = 0;
  static int _writeCallsNb = 0;
  static bool _initialized = false;

  static FileLogger? _instance;

  FileLogger._();

  ///Gets an instance from logger
  static FileLogger getInstant() {
    if (_instance == null) {
      _instance = FileLogger._();
    }
    return _instance!;
  }

  /// This function used to listen and create string from logs
  static void _initLogListener() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((rec) {
      var str =
          '${rec.level.name}: ${rec.loggerName}: ${rec.time}: ${rec.message}';
      print(rec.message);
      _writeToFile('$str\n');
    });
  }

  ///function used to switch between file paths when maximum file size
  ///is reached
  static void _switchPath() {
    _cumulativeSize = 0;
    _writeCallsNb = 0;
    if (_path == _path_1) {
      _path = _path_2;
    } else {
      _path = _path_1;
    }
    _file = File(_path);
    if (_file.lengthSync() > 0) {
      _clearFile();
    }
  }

  ///a function used to delete the content of a file
  static void _clearFile() {
    // TODO: implements what happens when we want to clear the file contents
    _file.writeAsStringSync('', mode: FileMode.write);
  }

  ///the function used to write data to the files when a new log is logged
  static void _writeToFile(String text) async {
    if (!_initialized) return;
    if (!_canWriteMoreToFile()) {
      _switchPath();
    }
    _file.writeAsStringSync(text,
        mode: FileMode.append, encoding: Encoding.getByName('utf-8')!);
    _cumulativeSize += text.length;
    _writeCallsNb++;
    if (_writeCallsNb > 30) {
      _checkCumulativeSizeAccuracy();
    }
  }

  ///function used for making sure that the cumulative save we are calculating
  ///is matching the real file size
  ///we do the check every 30 calls
  static void _checkCumulativeSizeAccuracy() {
    var size = _file.lengthSync();
    if (size != _cumulativeSize) {
      _cumulativeSize = size;
    }
    _writeCallsNb = 0;
  }

  ///this function returns true as long as we did not exceed the maximum limit
  static bool _canWriteMoreToFile() {
    //TODO: implements another efficient way for checking if needed
    return _cumulativeSize < _fileSize;
  }

  static File _exportLogFilesAsOneFile() {
    var logs1Content = '';
    var logs2Content = '';
    var logs1 = File(_path_1);
    var logs2 = File(_path_2);
    if (logs1.existsSync()) {
      logs1Content =
          logs1.readAsStringSync(encoding: Utf8Codec(allowMalformed: false));
    }
    if (logs2.existsSync()) {
      logs2Content =
          logs2.readAsStringSync(encoding: Utf8Codec(allowMalformed: false));
    }
    var exported = File('$_folderPath/logs.log');

    ///if file exists, clear the file otherwise create it
    if (exported.existsSync()) {
      exported.writeAsStringSync('',
          encoding: Utf8Codec(allowMalformed: true), mode: FileMode.write);
    } else {
      exported.createSync(recursive: true);
    }

    ///check for logs history order:
    bool pathOneIsFirst;
    if (_path == _path_1) {
      if (logs2Content.isNotEmpty) {
        pathOneIsFirst = false;
      } else {
        pathOneIsFirst = true;
      }
    } else {
      if (logs1Content.isNotEmpty) {
        pathOneIsFirst = true;
      } else {
        pathOneIsFirst = false;
      }
    }
    if (pathOneIsFirst) {
      exported.writeAsStringSync(logs1Content,
          encoding: Utf8Codec(allowMalformed: true), mode: FileMode.append);
      exported.writeAsStringSync(logs2Content,
          encoding: Utf8Codec(allowMalformed: false), mode: FileMode.append);
    } else {
      exported.writeAsStringSync(logs2Content,
          encoding: Utf8Codec(allowMalformed: true), mode: FileMode.append);
      exported.writeAsStringSync(logs1Content,
          encoding: Utf8Codec(allowMalformed: false), mode: FileMode.append);
    }
    return exported;
  }

  ///this function is used to export the log files as compressed tar file to the
  /// same directory of the files
  static File exportLogFilesAsZIPFile() {
    late File file;
    try {
      var encoder = ZipFileEncoder();

      encoder.create('$_folderPath/compressed.zip');
      var exported = _exportLogFilesAsOneFile();
      encoder.addFile(exported);
      encoder.close();
      file = File('$_folderPath/compressed.zip');
    } on Exception catch (error) {
      print(error);
    }
    return file;
  }

  ///this function creates the needed files for the logger
  void initializeLogger({required String logFilesLocation}) {
    assert(isNotEmpty(logFilesLocation));
    if (_initialized) return;
    _folderPath = logFilesLocation;
    _path_1 = '$logFilesLocation/logs1.log';
    _path_2 = '$logFilesLocation/logs2.log';
    var file1 = File(_path_1);
    var file2 = File(_path_2);
    if (!file1.existsSync()) {
      File(_path_1).createSync();
    }
    if (!file2.existsSync()) {
      File(_path_2).createSync();
    }
    _path = _path_1;
    _file = File(_path);
    _cumulativeSize = _file.lengthSync();
    _initialized = true;
    _initLogListener();
  }
}

//From github Fimber library:

/// Data size helper to help to calculate bytes/kilobytes, etc...
class DataSize {
  /// Kilo bytes value in bytes
  static const bytesInKilo = 1024;

  /// Mega bytes value in bytes
  static const byteInMega = bytesInKilo * bytesInKilo;

  /// Giga bytes value in bytes
  static const bytesInGiga = byteInMega * bytesInKilo;

  /// Tera bytes value in bytes
  static const bytesInTera = bytesInGiga * bytesInKilo;

  /// Real size in bytes.
  late int realSize;

  /// Create DataSize object with predefined size as optional.
  DataSize(
      {int kilobytes = 0,
      int megabytes = 0,
      int gigabytes = 0,
      int terabytes = 0,
      int? bytes = 0}) {
    if (bytes != null) {
      realSize = bytes;
    } else {
      realSize = 0;
    }
    realSize += kilobytes * bytesInKilo;
    realSize += megabytes * byteInMega;
    realSize += gigabytes * bytesInGiga;
    realSize += terabytes * bytesInTera;
  }

  @override
  String toString() {
    if (realSize / bytesInTera > 0) {
      return "${realSize / bytesInTera} TB";
    } else if (realSize / bytesInGiga > 0) {
      return "${realSize / bytesInGiga} GB";
    } else if (realSize / byteInMega > 0) {
      return "${realSize / byteInMega} MB";
    } else if (realSize / bytesInKilo > 0) {
      return "${realSize / bytesInKilo} KB";
    }
    return "$realSize B";
  }

  /// Creates DataSize object with bytes value.
  factory DataSize.bytes(int value) {
    return DataSize(bytes: value);
  }

  /// Creates DataSize object with kilo bytes value.
  factory DataSize.kilo(int value) {
    return DataSize(kilobytes: value);
  }

  /// Creates DataSize object with mega bytes value.
  factory DataSize.mega(int value) {
    return DataSize(megabytes: value);
  }

  /// Creates DataSize object with giga bytes value.
  factory DataSize.giga(int value) {
    return DataSize(gigabytes: value);
  }

  /// Creates DataSize object with tera bytes value.
  factory DataSize.tera(int value) {
    return DataSize(terabytes: value);
  }
}
