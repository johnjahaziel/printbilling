import 'package:blue_thermal_printer_plus/blue_thermal_printer_plus.dart';
import 'package:blue_thermal_printer_plus/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printer/styles.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final BlueThermalPrinterPlus printer = BlueThermalPrinterPlus();
  
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();

    devices = await printer.getBondedDevices();
    setState(() {});
  }

  Future<void> connectPrinter() async {
    if (selectedDevice == null) return;

    await printer.connect(selectedDevice!);
    bool? status = await printer.isConnected;

    setState(() => isConnected = status ?? false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: AlertDialog(
        backgroundColor: kwhite,
        constraints: BoxConstraints.tightFor(
          width: MediaQuery.of(context).size.width * 0.40,
        ),
        title: Text('Bluetooth Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text('Select Bluetooth device here.'),
                
                const SizedBox(height: 20),
                
                DropdownButton<BluetoothDevice>(
                  hint: const Text("Select Printer"),
                  value: selectedDevice,
                  isExpanded: true,
                  items: devices.map((device) {
                    return DropdownMenuItem(
                      value: device,
                      child: Text(device.name ?? device.address ?? ''),
                    );
                  }).toList(),
                  onChanged: (device) {
                    setState(() => selectedDevice = device);
                  },
                ),
                
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: connectPrinter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kblue,
                  ),
                  child: Text(
                    "CONNECT PRINTER",
                    style: TextStyle(
                      color: kwhite,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: kblue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}