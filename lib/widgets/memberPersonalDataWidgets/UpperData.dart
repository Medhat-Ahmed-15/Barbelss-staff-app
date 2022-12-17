import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpperContent extends StatelessWidget {
  const UpperContent({
    Key key,
  }) : super(key: key);

  Widget memberStatusContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: workConnectionStatus == 'offline'
            ? offlinePickedMember.isBlocked == true
                ? Colors.redAccent
                : Colors.green
            : pickedMember.isBlocked == true
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
            workConnectionStatus == 'offline'
                ? offlinePickedMember.isBlocked == true
                    ? AppLocalizations.of(context).blocked
                    : AppLocalizations.of(context).activeTitle
                : pickedMember.isBlocked == true
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
            workConnectionStatus == 'offline'
                ? offlinePickedMember.isBlocked == true
                    ? Icons.cancel_outlined
                    : Icons.check
                : pickedMember.isBlocked == true
                    ? Icons.cancel_outlined
                    : Icons.check,
            color: Theme.of(context).scaffoldBackgroundColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).primaryColor,
            radius: 35,
            child: Text(
              workConnectionStatus == 'offline'
                  ? offlinePickedMember.memberName.contains(' ')
                      ? offlinePickedMember.memberName[0].toUpperCase() +
                          offlinePickedMember.memberName
                              .split(' ')[1][0]
                              .toUpperCase()
                      : offlinePickedMember.memberName[0].toUpperCase()
                  : pickedMember.memberName.contains(' ')
                      ? pickedMember.memberName[0].toUpperCase() +
                          pickedMember.memberName.split(' ')[1][0].toUpperCase()
                      : pickedMember.memberName[0].toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          const SizedBox(
            width: 10,
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
                workConnectionStatus == 'offline'
                    ? offlinePickedMember.memberName
                    : pickedMember.memberName,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              workConnectionStatus == 'offline'
                  ? offlinePickedMember.memberName.length > 15 ||
                          MediaQuery.of(context).size.width < 370
                      ? memberStatusContainer(context)
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        )
                  : pickedMember.memberName.length > 15 ||
                          MediaQuery.of(context).size.width < 370
                      ? memberStatusContainer(context)
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        )
            ],
          ),
          Expanded(child: Container()),
          workConnectionStatus == 'offline'
              ? offlinePickedMember.memberName.length > 15 ||
                      MediaQuery.of(context).size.width < 370
                  ? const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : memberStatusContainer(context)
              : pickedMember.memberName.length > 15 ||
                      MediaQuery.of(context).size.width < 370
                  ? const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : memberStatusContainer(context)
        ],
      ),
    );
  }
}
