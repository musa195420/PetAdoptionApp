import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:petadoption/models/log_data.dart';

class LoggingService {
  late Logger _logger;
  late Directory _logDir;
  late File _currentLogFile;
  String _currentLogDate = DateTime.now().toString();

  Future<void> init() async {
    // Initialize the logger
    try {
      _logger = Logger(
        filter: ProductionFilter(),
        printer:
            PrettyPrinter(printEmojis: false, colors: false, methodCount: 0),
        level: Level.info,
      );

      // Get the application directory

      _logDir = await getDirectory();

      // Initialize log file handling
      _currentLogDate = _getCurrentDate();
      _currentLogFile = File('${_logDir.path}/log_$_currentLogDate.txt');
      await _createLogFileIfNeeded();

      // Set up a log file writer
      _logger = Logger(
        filter: ProductionFilter(),
        printer:
            PrettyPrinter(printEmojis: false, colors: false, methodCount: 0),
        level: Level.info,
        output: FileOutput(_currentLogFile),
      );
    } catch (e) {
      debugPrint("Error ${e.toString()}");
    }
  }

  void logInfo(String message) {
    _checkDateChange();
    _logger.i(
        "[INFO] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message");
  }

  void logVti(String message) {
    _checkDateChange();
    _logger.i(
        "[VTI] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message");
  }

  void logCC(String message, {bool request = true}) {
    _checkDateChange();
    if (request) {
      _logger.i(
          "[CC->Request] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message");
    } else {
      _logger.i(
          "[CC->Response] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message");
    }
  }

  void logWarning(String message) {
    _checkDateChange();
    _logger.w(
        "[WARNING] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message");
  }

  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _checkDateChange();
    _logger.e(
        "[ERROR] | ${DateFormat('hh:mm:ss').format(DateTime.now())} | $message",
        error: error,
        stackTrace: stackTrace);
  }

  void _checkDateChange() {
    final currentDate = _getCurrentDate();
    if (currentDate != _currentLogDate) {
      _currentLogDate = currentDate;
      _currentLogFile = File('${_logDir.path}/log_$_currentLogDate.txt');
      _createLogFileIfNeeded();
      _logger = Logger(
        filter: ProductionFilter(),
        printer:
            PrettyPrinter(printEmojis: false, colors: false, methodCount: 0),
        level: Level.info,
        output: FileOutput(_currentLogFile),
      );
    }
  }

  Future<LogData?> getLogs() async {
    final preData = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    var file = File('${_logDir.path}/log_$preData.txt');
    if (await file.exists()) {
      final fileStream = file.openRead();
      final contents = await fileStream.transform(utf8.decoder).join();
      return LogData(
          fileName: "log_$preData.txt", data: contents, date: preData);
    }
    return null;
  }

  Future<void> _createLogFileIfNeeded() async {
    if (!await _currentLogFile.exists()) {
      await _currentLogFile.create();
    }
  }

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<Directory> getDirectory() async {
    var directory = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      var externalDirectory = await getExternalStorageDirectory();
      if (externalDirectory != null) {
        directory = externalDirectory;
      }
    }
    return directory;
  }
}

class FileOutput extends LogOutput {
  final File _file;

  FileOutput(this._file);

  @override
  void output(OutputEvent event) {
    final buffer = StringBuffer();
    for (var line in event.lines) {
      buffer.writeln(line);
    }
    _file.writeAsStringSync(buffer.toString(), mode: FileMode.append);
  }
}
