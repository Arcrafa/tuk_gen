import 'package:flutter/material.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';

class ButtonApp extends StatelessWidget {

  Color color;
  Color textColor;
  String text;
  IconData icon;
  Function onPressed;
  bool gradient;
  List<Color> colors;
  ButtonApp({
    this.color = Colors.white,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    this.onPressed,
    @required this.text,
    this.colors=const [TRANSPARENTE,TRANSPARENTE]
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        onPressed();
      },
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      color: color,
      textColor: textColor,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(

          gradient:  LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors:this.colors
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 50,
                child: CircleAvatar(
                  radius: 15,
                  child: Icon(
                    icon,
                    color: PRIMARIO,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
