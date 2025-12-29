import 'dart:convert';

import 'package:blue_thermal_printer_plus/blue_thermal_printer_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:printer/bluetooth.dart';
import 'package:printer/customdrawer.dart';
import 'package:printer/styles.dart';

class Product {
  final int id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: int.parse(double.parse(json['price']).toStringAsFixed(0)),
    );
  }
}

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final BlueThermalPrinterPlus printer = BlueThermalPrinterPlus();
  
  final TextEditingController amount = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController kg = TextEditingController();
  final TextEditingController totalamount = TextEditingController();

  final TextEditingController search = TextEditingController();

  List<BillItem> billItems = [];

  int? selectedIndex;

  int get totalItems => billItems.length;

  int get grandTotal => billItems.fold(0, (sum, item) => sum + item.total);

  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadProducts() async {
    try {
      final result = await fetchProducts();
      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://billing.1bluetooth.com/api/shops/SHOP3/products');

    final response = await http.get(url);

    final data = json.decode(response.body);

    if (response.statusCode == 200) {

      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();

    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();

    loadProducts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Bluetooth(),
      );
    });

    quantity.addListener(updateSelectedItem);
    kg.addListener(updateSelectedItem);
  }

  void addItem(String name, int price) {
    setState(() {
      final index = billItems.indexWhere((e) => e.name == name);

      if (index != -1) {
        billItems[index].quantity++;
      } else {
        billItems.add(
          BillItem(
            name: name,
            quantity: 1,
            kg: 1,
            price: price,
          ),
        );
      }
    });
  }

  void updateSelectedItem() {
    if (selectedIndex == null) return;

    final item = billItems[selectedIndex!];

    final q = int.tryParse(quantity.text) ?? item.quantity;
    final k = int.tryParse(kg.text) ?? item.kg;

    setState(() {
      item.quantity = q;
      item.kg = k;

      totalamount.text = item.total.toString();
    });
  }

  void clearTopFields() {
    amount.clear();
    quantity.clear();
    kg.clear();
    totalamount.clear();
  }

  void printBill() async {
    if (!(await printer.isConnected ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Printer not connected")),
      );
      return;
    }

    printer.printCustom("SP MARY CHICKEN", 2, 1);
    printer.printCustom("STALL", 2, 1);
    printer.printCustom("Thalamuthu Nagar", 1, 1);
    printer.printCustom("CONTACT NO : 9790053143", 1, 1);

    printer.printCustom("--------------------------------", 1, 1);

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

    printer.printLeftRight("ITEM", "QTY KG TOTAL", 1);
    printer.printCustom("--------------------------------", 1, 1);

    for (final item in billItems) {
      printer.printCustom(item.name, 1, 0);

      printer.printLeftRight(
        "",
        "${item.quantity}   ${item.kg}   ${item.total}",
        1,
      );
    }

    printer.printCustom("--------------------------------", 1, 1);

    printer.printLeftRight(
      "NET TOTAL",
      "₹ $grandTotal",
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
    return SafeArea(
      child: Scaffold(
        drawer: Customdrawer(),
        backgroundColor: Colors.grey.shade100,
        body: Row(
          children: [
            
            SizedBox(
              height: double.infinity,
              width: 50,
              child: Column(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Bluetooth(),
                      );
                    },
                    icon: Icon(
                      Icons.bluetooth
                    )
                  )
                ],
              ),
            ),
      
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: search,
                            decoration: InputDecoration(
                              labelText: 'Search',
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              border: OutlineInputBorder(),
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.search
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            clearTopFields();
                          },
                          icon: Icon(
                            Icons.clear
                          )
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 55,
                    color: kblue,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          toptextfield(
                            'Amount',
                            amount
                          ),
                          toptextfield(
                            'Quantity',
                            quantity
                          ),
                          toptextfield(
                            'Kg',
                            kg
                          ),
                          toptextfield(
                            'Total Amount',
                            totalamount
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: billItems.length,
                        itemBuilder: (context, index) {
                          final item = billItems[index];
                          return _BillRow(
                            name: item.name,
                            quantity: item.quantity,
                            kg: item.kg,
                            price: item.total,
                            isSelected: selectedIndex == index,
                            onDelete: () {
                              setState(() {
                                billItems.removeAt(index);
                              });
                            },
                            onSelect: () {
                              setState(() {
                                selectedIndex = index;

                                quantity.text = item.quantity.toString();
                                kg.text = item.kg.toString();
                                amount.text = item.price.toString();
                                totalamount.text = item.total.toString();
                              });
                            },
                          );
                        },
                      )
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: kblue,
                    child: Row(
                      children: [
                        Text(
                          "ITEMS: $totalItems",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          "PAY ₹$grandTotal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : errorMessage != null
                                ? Center(child: Text(errorMessage!))
                                : GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final item = products[index];
                                      return _ItemButton(
                                        title: item.name.toUpperCase(),
                                        price: item.price,
                                        onTap: addItem,
                                      );
                                    },
                                  ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "Powered by BluonTech",
                            style: TextStyle(color: Color.fromARGB(255, 73, 73, 73), fontSize: 14),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RawMaterialButton(
                              fillColor: kblue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              onPressed: () {
                                if (billItems.isEmpty) return;

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => Printscreen(
                                //       billItems: billItems,
                                //       grandTotal: grandTotal,
                                //     ),
                                //   ),
                                // );

                                printBill();
                              },
                              child: Text(
                                'PRINT',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget toptextfield(String title, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5,bottom: 5,right: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: title,
              labelStyle: TextStyle(
                fontSize: 10
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BillItem {
  final String name;
  int quantity;
  int kg;
  int price;

  BillItem({
    required this.name,
    required this.quantity,
    required this.kg,
    required this.price,
  });

  int get total => quantity * kg * price;
}

class _BillRow extends StatelessWidget {
  final String name;
  final int quantity;
  final int kg;
  final int price;
  final VoidCallback onDelete;
  final VoidCallback onSelect;
  final bool isSelected;

  const _BillRow({
    required this.name,
    required this.price,
    required this.quantity,
    required this.kg,
    required this.onDelete,
    required this.onSelect,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onSelect,
      shape: Border.all(
        color: isSelected ? kblue : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                color: Colors.transparent,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
                color: Colors.transparent,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'X',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                color: Colors.transparent,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$kg',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
                color: Colors.transparent,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '=',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "₹ $price",
                    style: const TextStyle(fontSize: 14),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 18,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 0,
            child: Divider(),
          )
        ],
      ),
    );
  }
}

class _ItemButton extends StatelessWidget {
  final String title;
  final int price;
  final void Function(String title, int price) onTap;

  const _ItemButton({
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => onTap(title,price),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
        side: BorderSide(
          color: Colors.black,
        )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12
              )
            ),
            const SizedBox(height: 6),
            Text("₹ $price"),
          ],
        ),
      ),
    );
  }
}