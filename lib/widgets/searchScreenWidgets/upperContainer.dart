import 'package:animations/animations.dart';
import 'package:gym_staff_app/screens/addNewMemeberScreen.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter/material.dart';

class UpperContainer extends StatelessWidget {
  const UpperContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ZoomDrawer.of(context).toggle();
                },
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ),
              ),
              Image.asset(
                'assets/images/b8.png',
                height: 35,
                width: 35,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddNewMemberScreen.routeName);
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ),
              ),
            ],
          )),
    );
  }
}
