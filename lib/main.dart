import 'package:firebase/firebase_options.dart';
import 'package:firebase/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _future =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            //Sunucu ve uygulama arasında hata verirse bu çalışsın
            if (snapshot.hasError) {
              return Center(child: Text("Hatalı"));
              //Her şey yolundaysa bu çalışsın
            } else if (snapshot.hasData) {
              return MyHomePage();
              //Bilinmedik bi şey olursa bu çalışsın
            } else {
              return Container(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
