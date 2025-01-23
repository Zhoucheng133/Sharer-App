import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as p;

class Server {

  late String corePath;

  init() async {
    String supportDir=(await getApplicationSupportDirectory()).path;
    corePath=p.join(supportDir, Platform.isWindows ? "core.exe" : "core");
    final file = File(corePath);
    if(!file.existsSync()){
      final ByteData data = await rootBundle.load(Platform.isWindows ? "assets/core.exe" : "assets/core");
      final buffer = data.buffer.asUint8List();
      await file.writeAsBytes(buffer);
    }
    if (!Platform.isWindows) {
      await Process.run('chmod', ['+x', corePath]);
    }
  }

  Server(){
    init();
  }
}