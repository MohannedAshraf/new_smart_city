import 'package:flutter/material.dart';

class AllServices extends StatelessWidget {
  const AllServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Services')),
      body: const Center(child: Text('All services are displayed here!')),
    );
  }
}
