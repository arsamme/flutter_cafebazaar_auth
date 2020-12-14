import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CafeBazaarLoginButton extends StatelessWidget {
  /// Button Text
  final String text;
  /// Button Text TextStyle
  final TextStyle textStyle;
  /// Icon Size, for both width and height
  final double iconSize;
  /// OnPressed Callback
  final GestureTapCallback onPressed;

  CafeBazaarLoginButton({
    Key key,
    this.text: "ورود با بازار",
    this.textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.iconSize: 36,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff0EA960),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  'assets/images/bazaar.png',
                  package: "cafebazaar_auth",
                ),
                width: iconSize,
                height: iconSize,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Text(
                  text,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
