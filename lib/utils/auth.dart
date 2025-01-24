import 'package:flutter/material.dart';

class Auth {
  late String username;
  late String password;

  Auth(this.username, this.password);
}

Future<Auth> authDialog(BuildContext context) async {
  var usernameInput=TextEditingController();
  var passwordInput=TextEditingController();
  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: const Text("用户设置"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('用户名'),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                  ),
                  const SizedBox(height: 10,),
                  const Text('密码'),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordInput,
                          obscureText: true,
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
            ],
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            usernameInput.text="";
            passwordInput.text="";
          }, 
          child: const Text('取消')
        ),
        FilledButton(
          onPressed: (){
            if(usernameInput.text.isEmpty || passwordInput.text.isEmpty){
              showDialog(
                context: context, 
                builder: (context)=>AlertDialog(
                  title: const Text("用户设置失败"),
                  content: const Text('用户名和密码不能为空'),
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
            }else{
              Navigator.pop(context);
            }
          },
          child: const Text('完成')
        )
      ],
    )
  );

  return Auth(usernameInput.text, passwordInput.text);
}