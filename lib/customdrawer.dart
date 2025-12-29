import 'package:flutter/material.dart';
import 'package:printer/homescreen.dart';
import 'package:printer/login.dart';
import 'package:printer/styles.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {

  Future<void> logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.30,
      child: Padding(
        padding: const EdgeInsets.only(right: 60),
        child: Drawer(
          backgroundColor: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuicontitle(
                    Icons.home_outlined,
                    "Home",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homescreen()
                        )
                      );
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 24,
                      color: kred,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: kred,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Developed & Maintained By ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs10
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Bluon Tech',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fs10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey.withOpacity(0.4),
        height: 2,
      ),
    );
  }
}

menuicontitle(IconData icon, String title, VoidCallback onTap) => Padding(
  padding: EdgeInsets.symmetric(vertical: 5),
  child: ListTile(
    leading: Icon(
      icon,
      size: 22,
      color: kgrey,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: kgrey,
        fontSize: fs12
      ),
    ),
    onTap: onTap,
  ),
);