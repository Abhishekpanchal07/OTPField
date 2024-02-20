library easy_otpfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyOTPField extends StatefulWidget {
  final BuildContext context;
  final int otpFieldCount;
 final  Function(String  otpValue) onFieldFill;
 final bool? useRoundBorder;
 final Color? enabledBorderColor;

 final Color? focusBorderColor;
 final double? borderRadius;
  
   const EasyOTPField({super.key, 
   required this.otpFieldCount,
    required this.onFieldFill, 
    this.enabledBorderColor, 
    this.focusBorderColor,
     this.useRoundBorder,
     this.borderRadius,
     required this.context,
       });
  

  @override
  State<EasyOTPField> createState() => _CustomOTPFieldState();
}

class _CustomOTPFieldState extends State<EasyOTPField> {
   List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.otpFieldCount, (index) => TextEditingController());
    focusNodes = List.generate(widget.otpFieldCount, (index) => FocusNode());
  }

 

  @override
  Widget build(BuildContext context) {
   
     
    if ( widget.otpFieldCount > 0 &&  widget.otpFieldCount <= 6) {
      return  SizedBox(
      
       // color: Colors.black,
      height:MediaQuery.of(context).size.height * 0.07,
      width: widget.otpFieldCount <= 4 ? MediaQuery.of(context).size.width * 0.55 :MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: formKey,
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            _onKeyEvent(event, controllers, focusNodes,);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.otpFieldCount,
              (index) {
               

                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,),
                    child: Container(
                      decoration: const BoxDecoration(),
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration:  InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 4),
                          border: InputBorder.none,
                          counterText: "",
                          enabledBorder: widget.useRoundBorder  != null  && widget.useRoundBorder == true ? OutlineInputBorder(borderRadius:  BorderRadius.circular(widget.borderRadius ?? 10.0),borderSide:  BorderSide(color: widget.enabledBorderColor ??  Colors.grey),) :  UnderlineInputBorder(
                            borderSide: BorderSide(color: widget.enabledBorderColor ??  Colors.grey),
                          ),
                          focusedBorder: widget.useRoundBorder  != null && widget.useRoundBorder == true ? OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),borderSide:  BorderSide(color: widget.focusBorderColor ??  Colors.pink)):  UnderlineInputBorder(
                            borderSide: BorderSide(color: widget.focusBorderColor ??  Colors.pink),
                          ),
                        ),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                              if (index < widget.otpFieldCount - 1) {
                                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                              } else {
                                FocusScope.of(context).unfocus();
                            widget.onFieldFill(value);
                              }
                            } else {
                              if (index > 0) {
                                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                              }
                            }
                           
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    } else  {
      debugPrint(
        "OTPCount Should be Greater than 0 or smaller than 6 "
      );
    
    return   ErrorWidget.withDetails(message: "OTPCount Should be Greater than 0 or smaller than 6 ",);}
  
      
  }

  void _onKeyEvent(RawKeyEvent event, List<TextEditingController> controllers, List<FocusNode> focusNodes) {
  if (event is RawKeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      // Handle backspace key press
      for (int i = controllers.length - 1; i > 0; i--) {
        if (controllers[i].text.isEmpty && controllers[i - 1].text.isNotEmpty) {
          // Move focus to the previous field if the current field is empty and the previous field is not empty
          FocusScope.of(context).requestFocus(focusNodes[i - 1]);
          break;
        }
      }
    } else if (event.logicalKey == LogicalKeyboardKey.delete) {
      // Handle delete key press
      for (int i = 0; i < controllers.length - 1; i++) {
        if (controllers[i].text.isNotEmpty && controllers[i + 1].text.isEmpty) {
          // Move focus to the next field if the current field is not empty and the next field is empty
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          break;
        }
      }
    } else {
      // Handle other key presses (e.g., alphanumeric keys)
      // Find the last non-empty field
      int lastNonEmptyIndex = 0;
      for (int i = 0; i < controllers.length; i++) {
        if (controllers[i].text.isNotEmpty) {
          lastNonEmptyIndex = i;
        }
      }
      // Find the last empty field
      int lastEmptyIndex = controllers.length - 1;
      for (int i = controllers.length - 1; i >= 0; i--) {
        if (controllers[i].text.isEmpty) {
          lastEmptyIndex = i;
        }
      }
      // Determine the direction of navigation based on the last non-empty and empty fields
      if (lastNonEmptyIndex < lastEmptyIndex) {
        // Navigate to the next empty field if it exists
        FocusScope.of(context).requestFocus(focusNodes[lastEmptyIndex]);
      } else {
        // Navigate to the last non-empty field
        FocusScope.of(context).requestFocus(focusNodes[lastNonEmptyIndex]);
      }
    }
  }
  }


}
