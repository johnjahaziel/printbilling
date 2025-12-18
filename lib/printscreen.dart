import 'package:blue_thermal_printer_plus/blue_thermal_printer_plus.dart';
import 'package:blue_thermal_printer_plus/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printer/homescreen.dart';

class Printscreen extends StatefulWidget {
  final List<BillItem> billItems;
  final int grandTotal;

  const Printscreen({
    super.key,
    required this.billItems,
    required this.grandTotal,
  });

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

  void printBill() async {
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

    // DATE & TIME
    final now = DateTime.now();
    printer.printLeftRight(
      "DATE",
      "${now.day}-${now.month}-${now.year}",
      1,
    );
    printer.printLeftRight(
      "TIME",
      "${now.hour}:${now.minute}",
      1,
    );

    printer.printCustom("--------------------------------", 1, 1);

    // TABLE HEADER
    printer.printLeftRight("ITEM", "QTY KG TOTAL", 1);
    printer.printCustom("--------------------------------", 1, 1);

    // 🔥 PRINT EACH BILL ITEM
    for (final item in widget.billItems) {
      printer.printCustom(item.name, 1, 0);

      printer.printLeftRight(
        "",
        "${item.quantity}   ${item.kg}   ${item.total}",
        1,
      );
    }

    printer.printCustom("--------------------------------", 1, 1);

    // GRAND TOTAL
    printer.printLeftRight(
      "NET TOTAL",
      "₹ ${widget.grandTotal}",
      2,
    );

    printer.printCustom("--------------------------------", 1, 1);

    printer.printCustom("PAYMENT MODE : CASH", 1, 1);
    printer.printNewLine();
    printer.printCustom("THANK YOU! VISIT AGAIN", 1, 1);
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
              onPressed: isConnected ? printBill : null,
              child: const Text("PRINT BILL"),
            ),
          ],
        ),
      ),
    );
  }
}
