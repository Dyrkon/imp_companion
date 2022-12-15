import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imp/providers/ip_provider.dart';
import 'package:imp/screens/setting_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: IPProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool first = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var ipProvider = Provider.of<IPProvider>(context);
    ipProvider.ip = "192.168.4.1";

    return Scaffold(
      appBar: AppBar(
        title: Text("Bomba"),
        actions: [
          IconButton(
              onPressed: () async {
                var response = await http.get(
                  Uri.http(ipProvider.ip, '/start'),
                );
                if (response.statusCode != 200) {
                  print("Error");
                } else {
                  print("Game on");
                }
              },
              icon: const Icon(Icons.connect_without_contact_outlined))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: size.width,
          height: size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                var response = await http.get(
                  Uri.http(ipProvider.ip, '/switch'),
                );
                if (response.statusCode != 200) {
                  print("Error");
                } else {
                  setState(() {
                    first = jsonDecode(response.body)["first"] == true;
                  });
                }
              },
              child: const Text(
                "Změnit stranu",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
