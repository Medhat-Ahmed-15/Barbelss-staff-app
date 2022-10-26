import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemberPackageDetailsScreenCentralCard extends StatelessWidget {
  const MemberPackageDetailsScreenCentralCard({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      '${pickedMemberPackage.packageTitle} Package',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    pickedMemberPackage.isFreezed == true
                        ? Text(
                            '(${AppLocalizations.of(context).freezed})',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13),
                          )
                        : const Text('')
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${pickedMemberPackage.registrationAttended}/${pickedMemberPackage.packageAttendance}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
