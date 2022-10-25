import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../screens/memberPersonalDataScreen.dart';

class CentralCard extends StatelessWidget {
  const CentralCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150,
      left: 50,
      right: 50,
      child: Container(
        width: 100,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).primaryColor,
                radius: 45,
                child: Text(
                  pickedMember.memberName.contains(' ')
                      ? pickedMember.memberName[0].toUpperCase() +
                          pickedMember.memberName.split(' ')[1][0].toUpperCase()
                      : pickedMember.memberName[0].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                pickedMember.memberName,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, MemberPersonalDataScreen.routeName);
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).showMore,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
