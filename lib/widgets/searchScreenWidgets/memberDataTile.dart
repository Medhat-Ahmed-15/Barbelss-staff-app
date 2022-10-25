// ignore_for_file: file_names, missing_return

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/screens/memberDetailsScreen.dart';
import '../../assistant/assistantFunction.dart';

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
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(206, 206, 206, 1),
                offset: Offset(1, 3),
                blurRadius: 1.0,
              )
            ],
          ),
          child: Padding(
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
                          ? widget.memberData.memberName[0].toUpperCase() +
                              widget.memberData.memberName
                                  .split(' ')[1][0]
                                  .toUpperCase()
                          : widget.memberData.memberName[0].toUpperCase(),
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
                        Text(
                          '+${widget.memberData.countryCode}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.memberData.memberPhone,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  convertDateToDayInNumberMonthInText(
                      widget.memberData.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  pickedMember = widget.memberData;
                  print('Current member id:: ${pickedMember.memberId}');
                  print(
                      'Current member validation:: ${pickedMember.canAuthenticate}');

                  Navigator.pushNamed(context, MemberDetailsScreen.routeName);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
