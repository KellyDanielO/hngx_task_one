import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import 'web_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Slack Profile Picture
              SizedBox(
                width: width * .6,
                height: width * .6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(900),
                  child: Image.asset(
                    'assets/images/me.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(height: height * .02),
              // Slack name
              Text(
                'Kelly Daniel',
                style: TextStyle(
                  fontFamily: 'Alconica',
                  fontWeight: FontWeight.bold,
                  fontSize: width * .01 + 32,
                  color: AppColors.mainColor,
                ),
              ),
              // Open Github Button
              ElevatedButton(
                onPressed: () => Get.to(() => const WebViewScreen()),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    AppColors.primaryColor,
                  ),
                  elevation: MaterialStatePropertyAll(5),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(5, 5),
                      ),
                    ),
                  ),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.all(10),
                  ),
                ),
                child: Text(
                  'Open Github',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: width * .01 + 14,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
