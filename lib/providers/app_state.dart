import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  int _tabIndex = 0;
  List<String> _chat = [];

  bool get isLoggedIn => _isLoggedIn;
  int get tabIndex => _tabIndex;
  List<String> get chat => _chat;

  void login() { _isLoggedIn = true; notifyListeners(); }
  void logout() { _isLoggedIn = false; notifyListeners(); }
  void setTab(int i) { _tabIndex = i; notifyListeners(); }
  void sendMsg(String txt) {
    if (txt.isEmpty) return;
    _chat.add(txt);
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 600), () {
      _chat.add("Hello! I'm your AI local guide. I can tell you about food, views, or hotels for any place you select.");
      notifyListeners();
    });
  }
}