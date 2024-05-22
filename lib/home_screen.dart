import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'login_register_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //////////////
  String errorMessage = '';
  Position? userPosition;

  void getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage = 'Location services are disabled.';
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage = 'Location permissions are denied';
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage =
          'Location permissions are permanently denied, we cannot request permissions.';
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  void showLogoutDialog() {
    AlertDialog alert = AlertDialog(
      title: const Text("Fire-Auth"),
      content: const Text("Are you sure,you want to logout?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const LoginRegisterScreen(isLogin: true)));
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showLogoutDialog();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            'Email : ${widget.userEmail}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )),
          const SizedBox(height: 24),
          if (userPosition != null)
            Text(
              "Location Latitude : ${userPosition!.latitude}\nLocation Longitude : ${userPosition!.longitude}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (userPosition == null)
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
