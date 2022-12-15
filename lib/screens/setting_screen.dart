import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/ip_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ipProvider = Provider.of<IPProvider>(context);
    var size = MediaQuery.of(context).size;
    var ip = TextEditingController(text: ipProvider.ip);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            height: size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Nastavení",
                      style: TextStyle(fontSize: 24),
                    ),
                    TextFormField(
                      controller: ip,
                      decoration: const InputDecoration(
                        hintText: "Zadejte IP adresu na zařízení",
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                // if (formKey.currentState!.validate()) {
                                //
                                // }
                                ipProvider.ip = ip.text;
                                print(ipProvider.ip);
                                var response = await http.get(
                                  Uri.http(ipProvider.ip, '/start'),
                                );
                                if (response.statusCode != 200) {
                                  print("Error");
                                } else {
                                  Navigator.of(context).pop();
                                  print("Game on");
                                }
                              },
                              child: Text('Nastavit')),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
