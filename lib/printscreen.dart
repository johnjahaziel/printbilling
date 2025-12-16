import 'package:blue_thermal_printer_plus/blue_thermal_printer_plus.dart';
import 'package:blue_thermal_printer_plus/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Printscreen extends StatefulWidget {
  const Printscreen({super.key});

  @override
  State<Printscreen> createState() => _PrintscreenState();
}

class _PrintscreenState extends State<Printscreen> {
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

  void printTestBill() async {
    if (!(await printer.isConnected ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Printer not connected")),
      );
      return;
    }

    // HEADER
    printer.printCustom("SP MARY CHICKEN", 2, 1);
    printer.printCustom("STALL", 2, 1);
    printer.printCustom("Thalamuthu Nagar", 1, 1);
    printer.printCustom("CONTACT NO : 9790053143", 1, 1);

    printer.printCustom("--------------------------------", 1, 1);

    // BILL INFO
    printer.printLeftRight(
      "SERIAL NO 1",
      "16-12-2025",
      1,
    );
    printer.printLeftRight(
      "BILL NO 251216135",
      "11:20:26 AM",
      1,
    );

    printer.printCustom("--------------------------------", 1, 1);

    // TABLE HEADER
    printer.printLeftRight(
      "ITEM_NAME",
      "QTY  RATE  TOTAL",
      1,
    );

    printer.printCustom("--------------------------------", 1, 1);

    // ITEM NAME (FULL LINE)
    printer.printCustom("BONELESS CHICKEN", 1, 0);

    // ITEM VALUES (RIGHT ALIGNED)
    printer.printLeftRight(
      "",
      "2   300.00 600.00",
      1,
    );

    printer.printCustom("--------------------------------", 1, 1);

    // NET TOTAL (BOLD & BIG)
    printer.printLeftRight(
      "NET",
      "600.00",
      2,
    );

    printer.printCustom("--------------------------------", 1, 1);

    // PAYMENT MODE
    printer.printCustom("PAYMENT MODE : CASH", 1, 1);

    printer.printNewLine();

    // FOOTER
    printer.printCustom("THANK YOU ! VISIT AGAIN", 1, 1);
    printer.printNewLine();

    printer.paperCut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Printer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
              child: const Text("CONNECT PRINTER"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isConnected ? printTestBill : null,
              child: const Text("PRINT TEST BILL"),
            ),
          ],
        ),
      ),
    );
  }
}
