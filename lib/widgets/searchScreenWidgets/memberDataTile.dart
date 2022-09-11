// ignore_for_file: file_names, missing_return

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/screens/memberDetailsScreen.dart';

class MemberDataTile extends StatefulWidget {
  MemberData memberData;

  MemberDataTile(this.memberData);
  @override
  State<MemberDataTile> createState() => _MemberDataTileState();
}

class _MemberDataTileState extends State<MemberDataTile> {
  List colors = [
    Colors.blue[900],
    Colors.blue,
    Colors.grey,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.pink,
    Colors.purple
  ];
  Random random = Random();
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = random.nextInt(8);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    colors[index] /*Theme.of(context).primaryColor*/,
                foregroundColor: Theme.of(context).textTheme.headline1.color,
                radius: 30,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.memberData.memberName.contains(' ')
                        ? widget.memberData.memberName[0] +
                            widget.memberData.memberName.split(' ')[1][0]
                        : widget.memberData.memberName[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
              title: Text(
                widget.memberData.memberName,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.memberData.memberPhone,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // contentPadding: const EdgeInsets.all(4),
              // trailing: Icon(
              //   Icons.info,
              //   color: Theme.of(context).primaryColor,
              //   size: 25,
              // ),
              onTap: () {
                pickedMember = widget.memberData;

                Navigator.pushNamed(context, MemberDetailsScreen.routeName);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Divider(
          thickness: 1,
          endIndent: 10,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
