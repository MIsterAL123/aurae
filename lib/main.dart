import 'package:flutter/material.dart';

import 'app/aurae_app.dart';
import 'app/app_controller.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  final controller = AppController();
  await controller.restore();
  runApp(AuraeApp(controller: controller));
}
