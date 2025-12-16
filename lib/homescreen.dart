import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// TOP BAR
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search item",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              _topButton("PRINT"),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      /// BODY
      body: Row(
        children: [

          /// LEFT – BILL LIST
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: const [
                  _BillRow(name: "Boneless Chicken", price: 300),
                  _BillRow(name: "Country Chicken", price: 400),
                  _BillRow(name: "Kadai", price: 60),
                  _BillRow(name: "Without Skin", price: 250),
                  _BillRow(name: "With Skin", price: 220),
                ],
              ),
            ),
          ),

          /// RIGHT – ITEMS
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: const [
                  _ItemButton(title: "WITH SKIN", price: 220),
                  _ItemButton(title: "WITHOUT SKIN", price: 250),
                  _ItemButton(title: "BONELESS", price: 300),
                  _ItemButton(title: "KADAI", price: 60),
                  _ItemButton(title: "COUNTRY\nCHICKEN", price: 400),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: const Color.fromARGB(255, 0, 87, 150),
        child: Row(
          children: const [
            Text(
              "ITEMS: 5",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              )
            ),
            Spacer(),
            Text(
              "PAY ₹1230",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _topButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: RawMaterialButton(
        fillColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 87, 150),
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

/// BILL ROW
class _BillRow extends StatelessWidget {
  final String name;
  final int price;

  const _BillRow({
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "₹ $price",
                style: const TextStyle(fontSize: 12),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 18,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ITEM BUTTON
class _ItemButton extends StatelessWidget {
  final String title;
  final int price;

  const _ItemButton({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
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