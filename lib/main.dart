import 'package:chatbot/API/apis.dart';
import 'package:chatbot/Screens/splash_screen.dart';
import 'package:chatbot/helper/box.dart';
import 'package:chatbot/helper/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "credential.env");





  await Firebase.initializeApp();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Apis().initState();
   final dir = await getApplicationDocumentsDirectory();
   Hive.init(dir.path);
   box = await Hive.openBox('myData');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      home: Splashscrren(),
    );
  }
}
