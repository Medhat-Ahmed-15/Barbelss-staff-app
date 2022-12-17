import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../other/FourDotsLoading.dart';

class PolicyDialog extends StatelessWidget {
  final String mdFileName;

  PolicyDialog({@required this.mdFileName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 150))
                        .then((value) {
                      return DefaultAssetBundle.of(context)
                          .loadString('assets/$mdFileName');
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Markdown(
                          data: snapshot.data,
                        );
                      }
                      return FourDotsLoading();
                    })),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).scaffoldBackgroundColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      AppLocalizations.of(context).doneTitle,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
