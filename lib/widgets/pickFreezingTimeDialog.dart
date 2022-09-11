import 'package:flutter/material.dart';

class PickFreezingTimeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
