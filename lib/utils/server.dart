import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharer_app/utils/dialogs.dart';

// extern void StartServer(char* port, char* basePath, char* username, char* password);
// extern void StopServer();

typedef StartServer = void Function(Pointer<Utf8> port, Pointer<Utf8> basePath, Pointer<Utf8> username, Pointer<Utf8> password);
typedef StartServerFunc = Void Function(Pointer<Utf8> port, Pointer<Utf8> basePath, Pointer<Utf8> username, Pointer<Utf8> password);

typedef StopServer=void Function();
typedef StopServerFunc=Void Function();

class Server {
  late final SharedPreferences prefs;

  late DynamicLibrary dynamicLib;
  late StopServer stopServer;

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
  }

  Server(){
    init();
  }

  Future<bool> checkRun(BuildContext context, String port, String path) async {
    if(path.isEmpty){
      showErr(context, "启动服务失败", "分享路径不能为空");
      return false;
    }
    try {
      int intport=int.parse(port);
      if(intport<=1000 || intport>=100000){
        showErr(context, "启动服务失败", "端口号不合法");
        return false;
      }
    } catch (_) {
      showErr(context, "启动服务失败", "端口必须是数字");
      return false;
    }
    if(await portCheck(port)){
      return true;
    }
    if(context.mounted){
      showErr(context, "启动服务失败", "端口号被占用");
    }
    return false;
  }

  Future<bool> portCheck(String port) async {
    try {
      int portConvert=int.parse(port);
      final server = await ServerSocket.bind("0.0.0.0", portConvert);
      await server.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  Isolate? isolate;

  static void isolateFunction(List<String> params){
    final dynamicLib = DynamicLibrary.open(Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
    StartServer startServer=dynamicLib
        .lookup<NativeFunction<StartServerFunc>>('StartServer')
        .asFunction();

    startServer(
      params[0].toNativeUtf8(), // port
      params[1].toNativeUtf8(), // path
      params[2].toNativeUtf8(), // username
      params[3].toNativeUtf8(), // password
    );
  }

  Future<void> run(String username, String password, String port, String path) async {
    prefs.setString("port", port);
    prefs.setString("username", username);
    prefs.setString("password", password);
    prefs.setString("path", path);
    isolate=await Isolate.spawn(isolateFunction, [port, path, username, password]);
  }

  Future<void> stop() async {
    if (isolate != null) {
      await compute(stopServerHandler, Platform.isMacOS ? 'libserver.dylib' : 'libserver.dll');
      isolate!.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }

  static void stopServerHandler(String libName) {
    final lib = DynamicLibrary.open(libName);
    final stop = lib
        .lookup<NativeFunction<StopServerFunc>>('StopServer')
        .asFunction<StopServer>();
    stop();
  }
}