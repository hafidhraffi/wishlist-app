import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required String label,
    required Color color,
    required double width,
    required double height,
    required VoidCallback onPressed,
    required EdgeInsets padding,
    required BorderRadius borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
