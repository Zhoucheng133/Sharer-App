import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharer_app/utils/server.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  final server=Server();

  final pathInput=TextEditingController();
  final portInput=TextEditingController();
  final usernameInput=TextEditingController();
  final passwordInput=TextEditingController();
  bool useAuth=false;

  void init(){
    setState(() {
      portInput.text="8080";
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
                    onPressed: (){
                      // TODO 选取
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
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('用户名'),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: useAuth,
                                controller: usernameInput,
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
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('密码'),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: useAuth,
                                controller: passwordInput,
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
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  )
                ],
              ),
              Row(
                
              )
            ],
          ),
        )
      ],
    );
  }
}