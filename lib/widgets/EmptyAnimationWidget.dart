import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lot;

class EmptyAnimationWidget extends StatelessWidget {
  const EmptyAnimationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 200,
        height: 200,
        child: lot.LottieBuilder.asset('assets/gifs/empty.json'),
      ),
    );
  }
}
