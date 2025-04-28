import 'package:flutter/material.dart';

class SocialmediaProfile extends StatelessWidget {
  // final String uderId;

  const SocialmediaProfile({super.key /*required this.uderId*/});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // Adjust radius as needed
              // Optional: Add background color
              child: Image.network(
                'https://t3.ftcdn.net/jpg/02/38/58/46/240_F_238584633_pqi96ixQ7g9iSSw5mxFRDk7IEDNtT7g9.jpg',
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
