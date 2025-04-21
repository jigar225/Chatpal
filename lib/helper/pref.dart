// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';

// class Pref {
//   static late  Box _box;
//   static Future<void> initlizer() async {
//     Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
//     _box = Hive.box(name: 'myData ');
//   }

//   static bool get showonbording =>
//       _box!.get('showonbording', defaultValue: true);

//   static set showonbording(bool v) => _box.put('showonbording', v);
// }

import 'package:chatbot/helper/box.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
class Pref {
  // static late Box _box;

  // static Future<void> initializer() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path); // Fix: Use `Hive.init` not `Hive.defaultDirectory`
  // //  await Hive.initFlutter();
  //   _box = await Hive.openBox('myData'); // Fix: Removed space and used `openBox`
  // }

  static bool get showonbording =>box.get('showonbording', defaultValue: true);
  static set showonbording(bool v) => box.put('showonbording', v);
  static set username(String username)=>box.put('username', username);
  static String get username =>box.get('username',defaultValue: "Guest");
}
