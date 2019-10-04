import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String message) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text('Что то пошло не так'),
          content: Text(message??''),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        ));
