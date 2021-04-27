import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=943e367f");

void main() async {
  var response = await http.get(request);

  print(json.decode(response.body));

  runApp(MaterialApp(
    home: Container(),
  ));
}
