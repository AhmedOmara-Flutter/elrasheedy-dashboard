import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/services_locator.dart';
import 'core/src/src.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initAppModule();
  Bloc.observer = BlocObserverReader();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://ajxmzwehjmxdzcwfvght.supabase.co',
    publishableKey : 'sb_publishable__rv1VIGi6qrjfBubITJfEA_XW-VydVX',
  );

  runApp(MyApp());
}
