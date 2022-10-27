import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InternetConnectionError extends StatelessWidget {
  Function refresh;
  InternetConnectionError(this.refresh);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        SizedBox(
          width: 250,
          height: 250,
          child: lot.LottieBuilder.asset('assets/gifs/error.json'),
        ),
        SizedBox(
          width: 150,
          height: 45,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).scaffoldBackgroundColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            color:
                                Theme.of(context).textTheme.headline2.color)))),
            onPressed: () async {
              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text(
                AppLocalizations.of(context).tryAgain,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline2.color,
                    fontSize: 14),
              ),
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
