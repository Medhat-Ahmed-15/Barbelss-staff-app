import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmereffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Container(
          width: double.infinity,
          height: 8.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
