import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ExamDetailsScreen extends StatelessWidget {
  final double latitude; // Pass the latitude from your exam data
  final double longitude; // Pass the longitude from your exam data

  const ExamDetailsScreen({required this.latitude, required this.longitude});

  Future<void> _launchGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Exam Details'),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => _launchGoogleMaps(),
          child: const Text('Show on Google Maps'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}