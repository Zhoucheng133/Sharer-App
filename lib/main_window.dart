import 'package:flutter/material.dart';
import 'package:sharer_app/utils/server.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {

  final server=Server();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: (){
              server.run("8080", "/Users/zhoucheng/Downloads", "", "");
            }, 
            child: const Text("运行")
          ),
          TextButton(
            onPressed: (){
              server.stop();
            }, 
            child: const Text('停止')
          )
        ],
      ),
    );
  }
}