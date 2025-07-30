import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class Header extends StatelessWidget {
  final String waktu;
  final String user;

  const Header({super.key, required this.waktu, required this.user});

  Widget build(BuildContext context) {
    return Padding(
      // Wrap with Padding
      padding: const EdgeInsets.only(bottom: 12.0), // Add padding here
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waktu,
                  style: TextStyle(
                      color: theme.colorScheme.secondary, fontSize: 16),
                ),
                Text(
                  user,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const Stack(
            children: [
              Icon(Icons.notifications_none, size: 30),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "3",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
