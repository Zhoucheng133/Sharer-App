import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as p;
import 'package:process_run/process_run.dart';

class Server {

  late String corePath;
  late Shell shell;

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
    shell=Shell();
  }

  Server(){
    init();
  }

  String getCmd(String port, String dir, String username, String password){
    String cmd="'$corePath' -port $port -d '$dir'";
    if(username.isNotEmpty && password.isNotEmpty){
      cmd+=" -u $username -p $password";
    }
    return cmd;
  }

  Future<void> run(String port, String dir, String username, String password) async {
    try {
      await shell.run(getCmd(port, dir, username, password));
    } on ShellException catch (_) {}
  }

  void stop(){
    shell.kill();
  }
}