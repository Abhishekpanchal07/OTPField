

import 'package:easy_otpfield/custom_otpfield.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom OTP Field"),
      centerTitle: true,),
      body: Center(
        child: CustomOTPField(otpFieldCount: 4,
        enabledBorderColor: Colors.grey,
        focusBorderColor: Colors.pink,
        useRoundBorder: true, 
        onFieldsFill: (otpvalue){},),
      ),
    );
  }
}