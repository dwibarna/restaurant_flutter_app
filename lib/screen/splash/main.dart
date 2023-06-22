import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_flutter_app/model/restaurant.dart';

import '../detail/detail_screen.dart';
import '../main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/mainScreen': (context) => const MainScreen(),
        '/detailScreen': (context) => DetailScreen(ModalRoute.of(context)?.settings.arguments as Restaurant)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super (key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then((value) =>
    Navigator.pushReplacementNamed(context, '/mainScreen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/restaurant_logo.png",),
              width: 300,
            ),
            const SizedBox(height: 64,),
            SpinKitHourGlass(
              color: Colors.green.shade200,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}