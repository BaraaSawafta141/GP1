
  import 'package:flutter/material.dart';

  class CustomDrawer extends StatelessWidget {
    const CustomDrawer({Key? key});

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 250,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        //color: Colors.red,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/lang.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ahmed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("fakeEmail@gg.com"),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(
                  "History",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(
                  height: 30,
                ),

                const Text(
                  "About Us & FAQ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

