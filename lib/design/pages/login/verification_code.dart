import 'package:flutter/material.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';
import 'package:tuk_gen/design/atoms/otp_widget.dart';
import 'package:tuk_gen/design/atoms/button_app.dart';
import 'package:tuk_gen/core/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:tuk_gen/design/organisms/custom_keyboard/custom_keyboard.dart';

TextEditingController pin1Controller = new TextEditingController();
TextEditingController pin2Controller = new TextEditingController();
TextEditingController pin3Controller = new TextEditingController();
TextEditingController pin4Controller = new TextEditingController();
TextEditingController pin5Controller = new TextEditingController();
TextEditingController pin6Controller = new TextEditingController();

String sheetCode(context,verificationId,AuthProvider authProvider,FirebaseAuth firebaseAuth){
  String errorMessage;

  showModalBottomSheet<void>(
      context: context,
      isScrollControlled:true,
      //barrierColor:TRANSPARENTE,
      backgroundColor:TRANSPARENTE,
      builder: (context) {
        return Wrap(
          children: [ClipPath(
            clipper: WaveClipperOne(reverse: true,flip: true),
            child: Container(
              color: Colors.white,
              margin:  EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height*0.60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: OTPFields(
                      pin1: pin1Controller,
                      pin2: pin2Controller,
                      pin3: pin3Controller,
                      pin4: pin4Controller,
                      pin5: pin5Controller,
                      pin6: pin6Controller,
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: ButtonApp(
                      onPressed: () async {
                        String pin1 = pin1Controller.text.trim();
                        String pin2 = pin2Controller.text.trim();
                        String pin3 = pin3Controller.text.trim();
                        String pin4 = pin4Controller.text.trim();
                        String pin5 = pin5Controller.text.trim();
                        String pin6 = pin6Controller.text.trim();

                        String code = '$pin1$pin2$pin3$pin4$pin5$pin6';
                        try {

                          final credential = PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: code);
                          await firebaseAuth
                              .signInWithCredential(credential);
                        } catch (error) {
                          print(error);
                          errorMessage= error.code;
                        }
                        authProvider.login();
                      },
                      text: 'Verificar codigo',
                      colors: [SECUNDARIO, PRIMARIO, ACCENT2, ACCENT3],
                      textColor: Colors.white,
                    ),
                  ),
                  CustomKeyboard(
                    onTextInput: (myText) {
                      //TODO: implementar esta vaina para que cuando escriban si se inserte los numeros

                      // _insertText(myText);
                    },
                    onBackspace: () {
                      //_backspace();
                    },
                    onKeyboardHide: () {
                      //FocusScope.of(context).unfocus();
                      //overlayEntry.remove();
                    },
                  )
                ],
              ),
            ),
          ),
          ]
        );
      });
  return  errorMessage;
}