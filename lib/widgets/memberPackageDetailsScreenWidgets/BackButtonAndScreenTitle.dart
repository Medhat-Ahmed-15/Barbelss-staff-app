import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BackButtonAndScreenTitle extends StatelessWidget {
  const BackButtonAndScreenTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: localeLanguage == const Locale('en') ? 10 : 0,
      right: localeLanguage != const Locale('en') ? 10 : 0,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            pickedMemberPackage.packageTitle,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
