import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../utils/session_manager.dart';
import '../utils/session_manager_methods.dart';

/// a base class for any statful widget for checking internet connectivity
abstract class BaseState<T extends StatefulWidget> extends State with WidgetsBindingObserver{

  void castStatefulWidget();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  SessionManager sessionManager = SessionManager();

  /// the internet connectivity status
  bool isOnline = true;
  /// initialize connectivity checking
  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try
    {
      await _connectivity.checkConnectivity();
    }
    on PlatformException catch (e)
    {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
    {
      return;
    }

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
      isOnline = isConnected;
    }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {

      await _updateConnectionStatus().then((isConnected) {
        setState(() {
          isOnline = isConnected;
        });
      },);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    initConnectivity();
    if (state == AppLifecycleState.resumed)
    {
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
        await _updateConnectionStatus().then((isConnected) {
          if(mounted)
          {
            setState(() {
              isOnline = isConnected;
              print("isOnline didChangeAppLifecycleState === $isOnline");
              print("isConnected didChangeAppLifecycleState === $isConnected");
            });
          }
        },);
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try
    {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
      {
        isConnected = true;
      }
    }
    on SocketException catch (_)
    {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  Future<void> initSession() async {
    await SessionManagerMethods.init();
  }
}