import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

typedef StartServer = void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef StartServerFunc = Void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef StopServer=int Function();
typedef StopServerFunc=Int32 Function();


class Server {

  late String webPath;
  late DynamicLibrary dynamicLib;

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

  Isolate? isolate;
  static void isolateFunction(List<String> params){
    final dynamicLib = DynamicLibrary.open(Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
    StartServer startServer=dynamicLib
    .lookup<NativeFunction<StartServerFunc>>('StartServer')
    .asFunction();
    startServer(params[0].toNativeUtf8(), params[1].toNativeUtf8(), params[2].toNativeUtf8(), params[3].toNativeUtf8());
  }

  Future<void> run(String port, String dir, String username, String password) async {
    isolate=await Isolate.spawn(isolateFunction, [port, dir, username, password]);
  }

  Future<void> stop() async {
    if (isolate != null) {
      await compute(stopHandler, Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
      isolate!.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }

  static void stopHandler(String libName){
    final lib = DynamicLibrary.open(libName);
    final stop = lib
        .lookup<NativeFunction<StopServerFunc>>('StopServer')
        .asFunction<StopServer>();
    stop();
  }
}