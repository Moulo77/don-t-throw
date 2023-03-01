import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Reader extends StatefulWidget{
  const Reader({super.key});

  @override
  State<Reader> createState() => ReaderState();
}

class ReaderState extends State<Reader>{
  String _scanBarcode = 'Unknown';

  Future<void> barcodeScan() async{
    String barcodeScanRes;
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException{
      barcodeScanRes = "Failed to get platform version.";
    }

    if(!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
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
            Text('Scan result : $_scanBarcode\n',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                  ),
                  onPressed: () => barcodeScan(),
                  child: const Text('Barcode Scan',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold))),
            ),
          ]
      )
    );
  }
}