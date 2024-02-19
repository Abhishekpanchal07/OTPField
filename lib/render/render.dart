part of custom_otpfield;


class CustomOTPField extends StatefulWidget {
  final int otpFieldCount;
 final  Function(String  otpValue) onFieldsFill;
 final bool useRoundBorder;

 final Color? enabledBorderColor;

 final Color? focusBorderColor;
 final double? borderRadius;
  
  const CustomOTPField({super.key, required this.otpFieldCount, required this.onFieldsFill, this.enabledBorderColor, this.focusBorderColor,required this.useRoundBorder, this.borderRadius});
  

  @override
  State<CustomOTPField> createState() => _CustomOTPFieldState();
}

class _CustomOTPFieldState extends State<CustomOTPField> {
   List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  final formKey = GlobalKey<FormState>();
 

  @override
  Widget build(BuildContext context) {
   
    return Get.context !=null && widget.otpFieldCount == 4 ||  widget.otpFieldCount == 6 ?    SizedBox(
      height: Get.size.height * 0.06,
      width: widget.otpFieldCount == 4 ? Get.size.width * 0.55 : Get.size.width * 0.8,
      child: Form(
        key: formKey,
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            _onKeyEvent(event, controllers, focusNodes, widget.otpFieldCount);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.otpFieldCount,
              (index) {
                if (controllers.length <= index) {
                  controllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,),
                    child: TextFormField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:  InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        enabledBorder: widget.useRoundBorder ? OutlineInputBorder(borderRadius:  BorderRadius.circular( widget.borderRadius ?? 10.0),borderSide:  BorderSide(color: widget.enabledBorderColor ??  Colors.grey),) :  UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.enabledBorderColor ??  Colors.grey),
                        ),
                        focusedBorder: widget.useRoundBorder ? OutlineInputBorder(borderRadius: BorderRadius.circular( widget.borderRadius ?? 10.0),borderSide:  BorderSide(color: widget.focusBorderColor ??  Colors.pink)):  UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.focusBorderColor ??  Colors.pink),
                        ),
                      ),
                      maxLength: 1,
                      onChanged: (value) {
                        if(value.isNotEmpty){
                          widget.onFieldsFill(value);

                        }
                       else if(value.isNotEmpty && index == widget.otpFieldCount - 1){
                          FocusScope.of(Get.context!).unfocus();

                        }
                       else if (value.isNotEmpty && index < widget.otpFieldCount - 1) {
                          // Move focus to the next field if the current field is not empty and it's not the last field
                          FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          // Move focus to the previous field if the current field is empty
                          FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
                        }

                        // call callback if all controllers have values
                     

                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ) :  const SizedBox();
  }

  void _onKeyEvent(RawKeyEvent event, List<TextEditingController> controller, List<FocusNode> focusNodes, int otpFieldCount) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
              // Handle backspace key press
              for (int i = otpFieldCount - 1; i > 0; i--) {
                if (controller[i].text.isEmpty && controller[i - 1].text.isNotEmpty) {
                  // Move focus to the previous field if the current field is empty and the previous field is not empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i - 1]);
                  break;
                }
              }
            } else if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.delete) {
              // Handle delete key press
              for (int i = 0; i < otpFieldCount - 1; i++) {
                if (controller[i].text.isNotEmpty && controller[i + 1].text.isEmpty) {
                  // Move focus to the next field if the current field is not empty and the next field is empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i + 1]);
                  break;
                }
              }
            } else {
              // Handle other key presses
              for (int i = 0; i < otpFieldCount - 1; i++) {
                if (controller[i].text.isNotEmpty && controller[i + 1].text.isEmpty) {
                  // Move focus to the next field if the current field is not empty and the next field is empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i + 1]);
                  break;
                }
              }
            }
  }
}