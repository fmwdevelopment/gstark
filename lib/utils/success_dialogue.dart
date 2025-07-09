import 'package:flutter/material.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';

void showSuccessDialog(BuildContext context,String successContent) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Automatically close the dialog after 3 seconds

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Icon(Icons.check_circle, color: Colors.green,size: 48,),
        content: NormalText(text:successContent),
        // actions: <Widget>[
        //   TextButton(
        //     child: const Text("OK"),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],
      );
    },
  );
}
