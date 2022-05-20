import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final String url;
  const CheckoutPage({Key? key, required this.url}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://success.com')) {
                  Navigator.of(context)
                      .pop('success'); // <-- Handle success case
                } else if (request.url.startsWith('https://cancel.com')) {
                  Navigator.of(context).pop('cancel'); // <-- Handle cancel case
                }
                return NavigationDecision.navigate;
              })),
    );
  }
}
