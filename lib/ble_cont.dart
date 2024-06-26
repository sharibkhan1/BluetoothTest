import 'package:bluetooth/controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to BluetoothScanner when button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BluetoothScanner()),
            );
          },
          child: Text('Scan Bluetooth Devices'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
