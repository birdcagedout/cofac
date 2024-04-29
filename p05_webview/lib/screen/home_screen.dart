import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUri = Uri.parse("https://blog.codefactory.ai");

class HomeScreen extends StatelessWidget {

  WebViewController controller = WebViewController()..loadRequest(homeUri)..setJavaScriptMode(JavaScriptMode.unrestricted);
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text("CodeFactory Webview"),
        actions: [
          IconButton(icon: Icon(Icons.home), iconSize: 30, onPressed: () {controller.loadRequest(homeUri);},),
        ],
      ),
      body: WebViewWidget(controller: controller,),
    );
  }
}
