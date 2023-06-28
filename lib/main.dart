import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/utils/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('flavor')
      .invokeMethod<String>('getFlavor')
      .then((String? flavor) {
    if (kDebugMode) {
      print('STARTED WITH FLAVOR $flavor');
    }
    // if (flavor == 'PROD') {
    //   startProduction();
    // } else if (flavor == 'UAT') {
    //   startUAT();
    // }
  }).catchError((error) {
    if (kDebugMode) {
      print(error);
    }
    if (kDebugMode) {
      print('FAILED TO LOAD FLAVOR');
    }
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: "/",
    );
  }
}
