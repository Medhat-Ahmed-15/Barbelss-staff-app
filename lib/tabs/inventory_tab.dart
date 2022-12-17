import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/dialogs/feedBackDialog.dart';
import '../widgets/other/FourDotsLoading.dart';

class InventoryTab extends StatefulWidget {
  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  TextEditingController inventoryPriceController = TextEditingController();
  FocusNode inventoryPriceFocusNode = FocusNode();
  String inventoryPriceErrorMessage;

  TextEditingController inventoryAmountController = TextEditingController();
  FocusNode inventoryAmountFocusNode = FocusNode();
  String inventoryAmountErrorMessage;

  TextEditingController inventoryDescriptionController =
      TextEditingController();
  FocusNode inventoryDescriptionFocusNode = FocusNode();
  String inventoryDescriptionErrorMessage;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Price
            SizedBox(
              width: 200,
              child: TextField(
                controller: inventoryPriceController,
                keyboardType: TextInputType.number,
                onTap: () {
                  setState(() {
                    inventoryPriceErrorMessage = '';
                  });
                },
                focusNode: inventoryPriceFocusNode,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.price_change,
                      color: inventoryPriceFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: inventoryPriceFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: inventoryPriceFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  errorText: inventoryPriceErrorMessage == ''
                      ? null
                      : inventoryPriceErrorMessage,
                  labelText: 'Price',
                  hintText: 'ex: 30 EG',
                  labelStyle: TextStyle(
                    color: inventoryPriceFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //Amount
            SizedBox(
              width: 200,
              child: TextField(
                controller: inventoryAmountController,
                keyboardType: TextInputType.number,
                onTap: () {
                  setState(() {
                    inventoryAmountErrorMessage = '';
                  });
                },
                focusNode: inventoryAmountFocusNode,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.numbers,
                      color: inventoryAmountFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: inventoryAmountFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: inventoryAmountFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  errorText: inventoryAmountErrorMessage == ''
                      ? null
                      : inventoryAmountErrorMessage,
                  labelText: 'Amount',
                  hintText: 'ex: 15',
                  labelStyle: TextStyle(
                    color: inventoryAmountFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            //Description
            TextField(
              controller: inventoryDescriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onTap: () {
                setState(() {
                  inventoryDescriptionErrorMessage = '';
                });
              },
              focusNode: inventoryDescriptionFocusNode,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
              ),
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.text_snippet_rounded,
                    color: inventoryDescriptionFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: inventoryDescriptionFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: inventoryDescriptionFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                errorText: inventoryDescriptionErrorMessage == ''
                    ? null
                    : inventoryDescriptionErrorMessage,
                labelText: 'Description',
                hintText: 'ex: Supplements',
                labelStyle: TextStyle(
                  color: inventoryDescriptionFocusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                ),
              ),
            ),

            const SizedBox(
              height: 70,
            ),

            loading == true
                ? FourDotsLoading()
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {
                          try {
                            setState(() {
                              loading = true;
                            });

                            if (inventoryAmountController.text.trim().isEmpty ||
                                inventoryDescriptionController.text
                                    .trim()
                                    .isEmpty ||
                                inventoryPriceController.text.trim().isEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: AppLocalizations.of(context)
                                            .allFieldsMustBeFilled,
                                        gif: 'assets/gifs/fail.json',
                                        enableButton: true,
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
                                        callBackFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonColor: Colors.redAccent),
                              );
                              setState(() {
                                loading = false;
                              });

                              return;
                            }

                            await sendPayments(
                                double.parse(
                                    inventoryPriceController.text.trim()),
                                int.parse(
                                    inventoryAmountController.text.trim()),
                                inventoryDescriptionController.text.trim(),
                                'INVENTORY');
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) => FeedBackDialog(
                                  titleText: AppLocalizations.of(context)
                                      .paymentIsRecordedSuccessfully,
                                  gif: 'assets/gifs/success.json',
                                  enableButton: true,
                                  buttonText:
                                      AppLocalizations.of(context).doneTitle,
                                  callBackFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonColor: Theme.of(context).primaryColor),
                            );

                            setState(() {
                              loading = false;
                            });
                          } on SocketException {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) => FeedBackDialog(
                                  titleText: AppLocalizations.of(context)
                                      .connectionStatusMessage,
                                  gif: 'assets/gifs/fail.json',
                                  enableButton: true,
                                  buttonText:
                                      AppLocalizations.of(context).doneTitle,
                                  callBackFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonColor: Colors.redAccent),
                            );

                            setState(() {
                              loading = false;
                            });
                          } on GetRequestException catch (error) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) => FeedBackDialog(
                                  titleText: error.toStringMessage(),
                                  gif: 'assets/gifs/fail.json',
                                  enableButton: true,
                                  buttonText:
                                      AppLocalizations.of(context).doneTitle,
                                  callBackFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonColor: Colors.redAccent),
                            );
                            setState(() {
                              loading = false;
                            });
                          } catch (error) {
                            // showToast(
                            //     AppLocalizations.of(context).somethingWentWrong,
                            //     context);

                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context).submit,
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                fontSize: 16),
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
