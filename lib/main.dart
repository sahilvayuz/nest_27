import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String uiVariant = "icon_default";

  @override
  void initState() {
    super.initState();
    fetchVariant();
  }

  Future<void> fetchVariant() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );

    await remoteConfig.fetchAndActivate();

    setState(() {
      uiVariant = remoteConfig.getString("launcher_icon_variant");
      log("Remote Config UI variant = $uiVariant");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (uiVariant == "icon_festive")
          ? const FestiveScreen()
          : const DefaultScreen(),
    );
  }
}

// ------------------------- defaukt
class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "DEFAULT UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ------------------------- festive look
class FestiveScreen extends StatelessWidget {
  const FestiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: Text(
          "FESTIVE UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
