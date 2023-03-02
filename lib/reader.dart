import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Reader extends StatefulWidget{
  const Reader({super.key});

  @override
  State<Reader> createState() => ReaderState();
}

class ReaderState extends State<Reader>{
  String _scanBarcode = '';
  String _imgUrl = '';

  Future<void> barcodeScan() async{
    String barcodeScanRes;
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
      final response = await http.get(Uri.parse("https://world.openfoodfacts.org/api/v0/product/$barcodeScanRes.json"));
      if(response.statusCode==200){
        fetchProduct(response.body);
      }else{
        throw Exception('Failed to load product data');
      }
    } on PlatformException{
      barcodeScanRes = "Failed to get platform version.";
    }

    if(!mounted) return;
  }

  Future<void> fetchProduct(String response) async{
    final product = jsonDecode(response)['product'];
    final name = product['product_name'] ?? '';
    final imgUrl = product['selected_images']['front']['display']['fr'];

    setState(() {
      _scanBarcode = name;
      _imgUrl = imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            if(_scanBarcode.isNotEmpty)
              Text('Produit scanné : $_scanBarcode\n',
              style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.white)),
            if(_imgUrl.isNotEmpty)
              Image(
                image: NetworkImage(_imgUrl)
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan,
                      ),
                      onPressed: () => barcodeScan(),
                      child: const Text('Scanner un article',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                ),
              ),
          ]
      )
    );
  }
}