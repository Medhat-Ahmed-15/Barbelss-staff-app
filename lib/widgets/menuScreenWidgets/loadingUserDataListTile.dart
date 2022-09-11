// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class loadingUserDataListTile extends StatelessWidget {
  const loadingUserDataListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 20,
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          radius: 25,
        ),
      ),
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
