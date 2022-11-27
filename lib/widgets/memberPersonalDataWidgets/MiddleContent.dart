import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';

class MiddleContent extends StatelessWidget {
  const MiddleContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        padding: const EdgeInsets.only(
          left: 22,
          right: 22,
          top: 22,
          bottom: 22,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0.5),
                  blurRadius: 5.0)
            ],
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).emailTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              workConnectionStatus == 'offline'
                  ? offlinePickedMember.memberEmail == ''
                      ? AppLocalizations.of(context).emailHasNotBeenSpecified
                      : offlinePickedMember.memberEmail
                  : pickedMember.memberEmail == ''
                      ? AppLocalizations.of(context).emailHasNotBeenSpecified
                      : pickedMember.memberEmail,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),

            const Divider(
              endIndent: 20,
              indent: 20,
            ),

            ////////////////////////

            Text(
              AppLocalizations.of(context).phoneTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor),
            ),
            Text(
              workConnectionStatus == 'offline'
                  ? offlinePickedMember.memberPhone
                  : pickedMember.memberPhone,
              style: const TextStyle(
                  //  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.grey),
            ),
            const Divider(
              endIndent: 20,
              indent: 20,
            ),
            ///////////////////////////

            Text(
              AppLocalizations.of(context).id,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor),
            ),
            Text(
              workConnectionStatus == 'offline'
                  ? offlinePickedMember.memberId
                  : pickedMember.memberId,
              style: const TextStyle(
                  //  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.grey),
            ),
            const Divider(
              endIndent: 20,
              indent: 20,
            ),
          ],
        ),
      ),
    );
  }
}
