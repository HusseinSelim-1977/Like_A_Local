import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlScreen extends StatefulWidget {
  const HtmlScreen({super.key});
  @override
  State<HtmlScreen> createState() => _HtmlScreenState();
}

class _HtmlScreenState extends State<HtmlScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/index.html');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('LikeALocal')), body: WebViewWidget(controller: _controller));
  }
}