import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.radius});

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Container(
          width: 50, height: 59, child: Image.asset("asset/img/icon/aibot.png")),
    );
  }
}
