import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sharer_app/lang/en_us.dart';
import 'package:sharer_app/lang/zh_cn.dart';
import 'package:sharer_app/lang/zh_tw.dart';
import 'package:sharer_app/main_window.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  const size=Size(400, 310);
  WindowOptions windowOptions = const WindowOptions(
    size: size,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "Sharer",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    windowManager.setResizable(false);
  });

  runApp(const MainApp());
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
  };
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      translations: MainTranslations(),
      locale: Get.deviceLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: brightness==Brightness.dark ? Brightness.dark : Brightness.light,
        fontFamily: 'PuHui', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: brightness==Brightness.dark ? Brightness.dark : Brightness.light,
        ),
        textTheme: brightness==Brightness.dark ? ThemeData.dark().textTheme.apply(
          fontFamily: 'PuHui',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ) : ThemeData.light().textTheme.apply(
          fontFamily: 'PuHui',
        ),
      ),
      home: const Scaffold(
        body: MainWindow()
      ),
    );
  }
}
