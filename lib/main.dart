import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=943e367f");

void main() async {
  print(await getData());

  runApp(MaterialApp(
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        textTheme: TextTheme(subtitle1: TextStyle(color: Colors.amber)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.amber),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          disabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
    home: Home(),
  ));
}

Future<Map> getData() async {
  var response = await http.get(request);

  return (json.decode(response.body));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          '\$ Conversor \$',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    'Carregando dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar dados :(',
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                        ),
                        buildTextField(
                            'Real', 'R\$ ', realController, _realOnChange),
                        Divider(),
                        buildTextField(
                            'Dolar', '\$ ', dolarController, _dolarOnChange),
                        Divider(),
                        buildTextField(
                            'Euro', '€ ', euroController, _euroOnChange)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChanged) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: label, prefixText: prefix),
    onChanged: onChanged,
    keyboardType: TextInputType.number,
  );
}
