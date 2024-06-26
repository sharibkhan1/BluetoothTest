import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;

  // Function to scan nearby BLE devices and get the list of Bluetooth devices.
  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        ble.startScan(timeout: Duration(seconds: 15));
      }
    }
  }

  // Function to connect to a BLE device.
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (device != null) {
      try {
        await device.connect(timeout: Duration(seconds: 15));

        device.state.listen((state) {
          if (state == BluetoothDeviceState.connected) {
            print("Device connected: ${device.name}");
            // Handle further actions upon successful connection
          } else if (state == BluetoothDeviceState.disconnected) {
            print("Device disconnected: ${device.name}");
            // Handle disconnection scenarios if needed
          }
        });
      } catch (e) {
        print("Error connecting to device: $e");
      }
    } else {
      print("Invalid device provided.");
    }
  }

  // Stream of scan results.
  Stream<List<ScanResult>> get scanResults => ble.scanResults;
}
