import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/helper/object_box.dart';
import 'package:gym_staff_app/providers/offlineFeature_provider.dart';
import 'package:gym_staff_app/screens/searchScreen.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../assistant/assistantFunction.dart';

class InternetConnectionError extends StatefulWidget {
  Function refresh;
  InternetConnectionError(this.refresh);

  @override
  State<InternetConnectionError> createState() =>
      _InternetConnectionErrorState();
}

class _InternetConnectionErrorState extends State<InternetConnectionError> {
  bool loading = false;

  Widget button(
      BuildContext context,
      Function onPressFunction,
      String buttonText,
      Color buttonColor,
      Color textColor,
      Color borderColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        height: 45,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: borderColor)))),
          onPressed: onPressFunction,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              buttonText,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: lot.LottieBuilder.asset('assets/gifs/error.json'),
        ),
        button(
          context,
          () async {
            widget.refresh();
          },
          AppLocalizations.of(context).tryAgain,
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
        ),
        loading == true
            ? FourDotsLoading()
            : button(
                context,
                () async {
                  setState(() {
                    loading = true;
                  });

                  Navigator.of(context).popUntil(ModalRoute.withName('/'));

                  await Provider.of<OfflineFeautureProvider>(context,
                          listen: false)
                      .setWorkStatusInStorage('offline');
                  ObjectBox.getClubData();

                  setState(() {
                    loading = false;
                  });
                },
                AppLocalizations.of(context).workOffline,
                Colors.grey,
                Theme.of(context).scaffoldBackgroundColor,
                Colors.grey,
              ),
        Expanded(child: Container()),
      ],
    );
  }
}
