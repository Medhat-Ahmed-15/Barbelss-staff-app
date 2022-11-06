import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpperContent extends StatelessWidget {
  const UpperContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 36.0,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            radius: 34.0,
            child: const Icon(
              Icons.person,
              color: Colors.grey,
              size: 50,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).nameHint,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              pickedMember.memberName,
              style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.grey),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: pickedMember.isBlocked == true
                ? Colors.redAccent
                : Colors.green,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pickedMember.isBlocked == true
                    ? AppLocalizations.of(context).blocked
                    : AppLocalizations.of(context).activeTitle,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                pickedMember.isBlocked == true
                    ? Icons.cancel_outlined
                    : Icons.check,
                color: Theme.of(context).scaffoldBackgroundColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}
