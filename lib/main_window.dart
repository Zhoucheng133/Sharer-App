import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharer_app/utils/auth.dart';
import 'package:sharer_app/utils/server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  final server=Server();

  late SharedPreferences prefs;

  final pathInput=TextEditingController();
  final portInput=TextEditingController();
  String usernameInput="";
  String passwordInput="";
  bool useAuth=false;
  String address="";

  bool running=false;

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
    final port=prefs.getString('port');
    final path=prefs.getString('path');
    final username=prefs.getString('username');
    final password=prefs.getString('password');
    if(port!=null && port.isNotEmpty){
      setState(() {
        portInput.text=port;
      });
    }else{
      setState(() {
        portInput.text="8080";
      });
    }
    if(path!=null && path.isNotEmpty){
      setState(() {
        pathInput.text=path;
      });
    }
    if(username!=null && password!=null && username.isNotEmpty && password.isNotEmpty){
      setState(() {
        usernameInput=username;
        passwordInput=password;
        useAuth=true;
      });
    }
  }

  Future<void> getAddress() async {
    final interfaces = await NetworkInterface.list();
    for (final interface in interfaces) {
      final addresses = interface.addresses;
      final localAddresses = addresses.where((address) => !address.isLoopback && address.type.name=="IPv4");
      for (final localAddress in localAddresses) {
        setState(() {
          address=localAddress.address;
        });
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    getAddress();
    windowManager.addListener(this);
  }

 @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 30,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              Platform.isWindows ? Row(
                children: [
                  WindowCaptionButton.minimize(onPressed: windowManager.minimize,),
                  WindowCaptionButton.close(onPressed: windowManager.close,)
                ],
              ) : Container()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('分享路径:'),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: pathInput,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 52, 93, 136), width: 1.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 52, 93, 136), width: 2.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  FilledButton(
                    onPressed: () async {
                      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                      if (selectedDirectory!=null) {
                        setState(() {
                          pathInput.text=selectedDirectory;
                        });
                      }
                    }, 
                    child: const Text('选取')
                  )
                ],
              ),
              const SizedBox(height: 10,),
              const Text('端口:'),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: portInput,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 52, 93, 136), width: 1.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 52, 93, 136), width: 2.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      autocorrect: false,
                      enableSuggestions: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue){
                          if(newValue.text.length>5){
                            return oldValue;
                          }
                          return newValue;
                        })
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Checkbox(
                    value: useAuth, 
                    splashRadius: 0,
                    onChanged: (val){
                      if(val!=null){
                        setState(() {
                          useAuth=val;
                        });
                      }
                    }
                  ),
                  GestureDetector(
                    onTap: ()=>setState(() {
                      useAuth=!useAuth;
                    }),
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text("启用登录")
                    )
                  ),
                  Expanded(child: Container()),
                  FilledButton(
                    onPressed: useAuth ? () async {
                      final data=await authDialog(context, usernameInput, passwordInput);
                      setState(() {
                        usernameInput=data.username;
                        passwordInput=data.password;
                      });
                      if(usernameInput.isEmpty && passwordInput.isEmpty){
                        setState(() {
                          useAuth=false;
                        });
                      }
                    } : null, 
                    child: const Text('用户设置')
                  )
                ],
              ),
              const SizedBox(height: 10,),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Icon(
                    Icons.podcasts_rounded,
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () async {
                      if(running){
                        try {
                          await launchUrl(Uri.parse("http://$address:${portInput.text}"));
                        } catch (_) {}
                      }
                    },
                    child: MouseRegion(
                      cursor: running ? SystemMouseCursors.click : SystemMouseCursors.forbidden ,
                      child: Text("$address:${portInput.text}")
                    )
                  ),
                  Expanded(child: Container()),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: running, 
                      splashRadius: 0,
                      onChanged: (val) async {
                        if(val){
                          if(pathInput.text.isEmpty || !server.dirCheck(pathInput.text)){
                            if(context.mounted){
                              showDialog(
                                context: context, 
                                builder: (context)=>AlertDialog(
                                  title: const Text('启动失败'),
                                  content: const Text("没有选取路径或者路径不合法"),
                                  actions: [
                                    FilledButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text('好的')
                                    )
                                  ],
                                )
                              );
                            }
                          }else if(portInput.text.isEmpty){
                            if(context.mounted){
                              showDialog(
                                context: context, 
                                builder: (context)=>AlertDialog(
                                  title: const Text('启动失败'),
                                  content: const Text("端口号不合法"),
                                  actions: [
                                    FilledButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text('好的')
                                    )
                                  ],
                                )
                              );
                            }
                          }else if(!(await server.portCheck(portInput.text))){
                            if(context.mounted){
                              showDialog(
                                context: context, 
                                builder: (context)=>AlertDialog(
                                  title: const Text('启动失败'),
                                  content: const Text("端口冲突，你需要更换端口号"),
                                  actions: [
                                    FilledButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text('好的')
                                    )
                                  ],
                                )
                              );
                            }
                          }else{
                            server.run(portInput.text, pathInput.text, useAuth ? usernameInput : "", useAuth ? passwordInput : "");
                            prefs.setString("port", portInput.text);
                            prefs.setString("path", pathInput.text);
                            if(!useAuth){
                              prefs.setString("username", "");
                              prefs.setString("password", "");
                            }
                            setState(() {
                              running=true;
                            });
                          }
                        }else{
                          server.stop();
                          setState(() {
                            running=false;
                          });
                        }
                      }
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}