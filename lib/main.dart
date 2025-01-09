import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the Provider package
import 'splash_screen.dart'; // Import the SplashScreen
import 'providers/cart_state.dart'; // Import your CartState

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider( // Use MultiProvider to add more providers in the future
      providers: [
        ChangeNotifierProvider(create: (_) => CartState()), // Register CartState
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Yours Gadget E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(), // Start with SplashScreen
    );
  }
}
