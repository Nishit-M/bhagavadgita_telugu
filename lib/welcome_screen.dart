import 'package:bhagavadgita_telugu/chapters_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChaptersScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('./assets/images/Krishna-1.png'),
              fit: BoxFit.cover, // Ensures the image fills the screen
            ),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 32, 181, 240).withOpacity(0.5),
                Colors.white.withOpacity(0.1)
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Haree Krishna',
                style: TextStyle(color: Colors.amber, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
