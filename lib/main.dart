// Import the firebase_core plugin
import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medicine_inventory/controller/inventory_controller.dart';
import 'package:medicine_inventory/database/isar_helper.dart';
import 'package:medicine_inventory/screen/inventory_list_page.dart';
import 'package:provider/provider.dart';

ValueNotifier<bool> isDeviceConnected = ValueNotifier(false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    IsarHelper.instance.init();
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected.value = await InternetConnectionChecker().hasConnection;
      log("Internet status ====== $isDeviceConnected");
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InventoryController(),
        ),
      ],
      child: const GetMaterialApp(
        home: InventoryListPage(),
      ),
    );
  }
}

//something went wrong
class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Something went wrong \nPlease try again',textAlign: TextAlign.center,),
      ),
    );
  }
}
