import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScanner extends StatefulWidget {
  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() async {
    // Request location permission first
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    // Check if permission is granted
    if (await Permission.location.isGranted) {
      // Start scanning for Bluetooth devices
      flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devices.contains(result.device)) {
            setState(() {
              devices.add(result.device);
            });
          }
        }
      });

      flutterBlue.startScan();
    } else {
      // Handle denied or restricted permissions
      print('Location permission denied');
    }
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name ?? 'Unknown device'),
            subtitle: Text(devices[index].id.toString()),
            onTap: () {
              _connectToDevice(devices[index]);
            },
          );
        },
      ),
    );
  }

  void _connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
    }

    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      _discoverServices(device);
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void _discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        print('Service found: ${service.uuid}');
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          print('Characteristic found: ${characteristic.uuid}');
        }
      }
    } catch (e) {
      print('Error discovering services: $e');
    }
  }
}


void main() {
  runApp(MaterialApp(
    home: BluetoothScanner(),
  ));
}
