import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as p;
import 'package:shared_preferences/shared_preferences.dart';

typedef StartServer = void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef StartServerFunc = Void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef StopServer=int Function();
typedef StopServerFunc=Int32 Function();


class Server {

  late String webPath;
  late DynamicLibrary dynamicLib;
  late StopServer stopServer;

  init() async {

    
    dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
    stopServer=dynamicLib
    .lookup<NativeFunction<StopServerFunc>>('StopServer')
    .asFunction();
    

    String supportDir=(await getApplicationSupportDirectory()).path;
    webPath=p.join(supportDir, "dist");

    List<String> assetFiles = [
      "assets/dist/index.html",
      "assets/dist/vite.svg",
      "assets/dist/assets/index-BGsdZcFV.css",
      "assets/dist/assets/index-DRqKvH6v.js",
      "assets/dist/assets/primeicons-C6QP2o4f.woff2",
      "assets/dist/assets/primeicons-DMOk5skT.eot",
      "assets/dist/assets/primeicons-Dr5RGzOO.svg",
      "assets/dist/assets/primeicons-MpK4pl85.ttf",
      "assets/dist/assets/primeicons-WjwUDZjB.woff",
    ];

    Directory webDir = Directory(webPath);

    final pref=await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final prefsVersion=pref.getString("version");
    final version=packageInfo.version;

    if(webDir.existsSync()){
      if(prefsVersion!=version){
        webDir.deleteSync(recursive: true);
        pref.setString("version", version);
      }
    }

    if(!webDir.existsSync()){

      for (String assetPath in assetFiles) {
        final file = File(p.join(supportDir, p.relative(assetPath, from: "assets")));
        final ByteData data = await rootBundle.load(assetPath);
        final buffer = data.buffer.asUint8List();
        final localDir=Directory(p.join(supportDir, p.dirname(p.relative(assetPath, from: "assets"))));
        if(!localDir.existsSync()){
          await localDir.create(recursive: true);
        }
        await file.writeAsBytes(buffer);
      }
    }
  }

  Server(){
    init();
  }

  Future<bool> portCheck(String port) async {
    try {
      int portConvert=int.parse(port);
      final server = await ServerSocket.bind("0.0.0.0", portConvert);
      await server.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool dirCheck(String dir){
    final directory = Directory(dir);
    return directory.existsSync();
  }

  late Isolate isolate;
  static void isolateFunction(List<String> params){
    final dynamicLib = DynamicLibrary.open(Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
    StartServer startServer=dynamicLib
    .lookup<NativeFunction<StartServerFunc>>('StartServer')
    .asFunction();
    // port *C.char, basePath *C.char, username *C.char, password *C.char, webPath *C.char
    startServer(params[0].toNativeUtf8(), params[1].toNativeUtf8(), params[2].toNativeUtf8(), params[3].toNativeUtf8(), params[4].toNativeUtf8());
  }

  Future<void> run(String port, String dir, String username, String password) async {
    isolate=await Isolate.spawn(isolateFunction, [port, dir, username, password, webPath]);
  }

  void stop(){
    stopServer();
    isolate.kill();
  }
}