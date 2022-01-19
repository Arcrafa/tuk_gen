import 'package:flutter/material.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';

class CustomKeyboard extends StatelessWidget {
  CustomKeyboard({
    Key key,
    this.onTextInput,
    this.onBackspace,
    this.onKeyboardHide,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onKeyboardHide;

  void _textInputHandler(String text) => onTextInput?.call(text);

  void _backspaceHandler() => onBackspace?.call();

  void _onKeyboardHideHandler() => onKeyboardHide?.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      /*decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [SECUNDARIO, PRIMARIO,ACCENT2]))*/
        color:Colors.white,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextKey(
                text: '1',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '2',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '3',
                onTextInput: _textInputHandler,
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextKey(
                text: '4',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '5',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '6',
                onTextInput: _textInputHandler,
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextKey(
                text: '7',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '8',
                onTextInput: _textInputHandler,
              ),
              TextKey(
                text: '9',
                onTextInput: _textInputHandler,
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KeyboardHide(
                onHeyboardHide: _onKeyboardHideHandler,
              ),
              TextKey(
                text: '0',
                onTextInput: _textInputHandler,
              ),
              BackspaceKey(
                onBackspace: _backspaceHandler,
              )
            ],
          )
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key key,
    @required this.text,
    this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MaterialButton(
          height: 50.0,
          minWidth: 50.0,
          shape: CircleBorder(),
          color: SECUNDARIO,
          splashColor: ACCENT,
          onPressed: () => {onTextInput?.call(text)},
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key key,
    this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MaterialButton(
          height: 50.0,
          minWidth: 50.0,
          splashColor: ACCENT,
          shape: CircleBorder(),
          color: TRANSPARENTE,
          onPressed: () => {onBackspace?.call()},
          child:  Container(
            child: Center(
              child: Icon(
                Icons.backspace,
                color: Colors.white,
              ),
            ),
          ),

        ),
      ),
    );
  }
}

class KeyboardHide extends StatelessWidget {
  const KeyboardHide({
    Key key,
    this.onHeyboardHide,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback onHeyboardHide;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MaterialButton(
          height: 50.0,
          minWidth: 50.0,
          splashColor: ACCENT,
          shape: CircleBorder(),
          color: TRANSPARENTE,
          onPressed: () => {onHeyboardHide?.call()},
          child:  Container(
              child: Center(
                child: Icon(
                  Icons.keyboard_hide,
                  color: Colors.white,
                ),
              ),
            ),

        ),
      ),
    );
  }
}
