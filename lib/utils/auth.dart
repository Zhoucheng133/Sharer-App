import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Auth {
  late String username;
  late String password;

  Auth(this.username, this.password);
}

Future<Auth> authDialog(BuildContext context, String usernameIn, String passwordIn) async {
  var usernameInput=TextEditingController();
  var passwordInput=TextEditingController();
  usernameInput.text=usernameIn;
  passwordInput.text=passwordIn;
  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text("authConfig".tr),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.notoSansSc(
                            fontSize: 14,
                          ),
                          controller: usernameInput,
                          decoration: InputDecoration(
                            labelText: "username".tr,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.notoSansSc(
                            fontSize: 14,
                          ),
                          controller: passwordInput,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "password".tr,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
          child: Text('cancel'.tr)
        ),
        FilledButton(
          onPressed: (){
            if(usernameInput.text.isEmpty || passwordInput.text.isEmpty){
              showDialog(
                context: context, 
                builder: (context)=>AlertDialog(
                  title: Text("configErr".tr),
                  content: Text('emptyUsernamePassword'.tr),
                  actions: [
                    FilledButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text('ok'.tr)
                    )
                  ],
                )
              );
            }else{
              Navigator.pop(context);
            }
          },
          child: Text('ok'.tr)
        )
      ],
    )
  );

  return Auth(usernameInput.text, passwordInput.text);
}