import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/widgets/custom_button.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height / 16,
          ),
          const Center(
            child: Text(
              'Welcome to WhatsApp',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Image.asset(
            'assets/images/bg.png',
            height: 300,
            width: 300,
            color: tabColor,
          ),
          SizedBox(
            height: size.height / 9,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Read our Privacy Policy , Tap "Agree and Continue" to accept the Terms of Service',
              style: TextStyle(
                color: greyColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: 'Agree and Continue',
                onPressed: ()=>navigateToLoginScreen(context),
              ))
        ],
      )),
    );
  }
}
