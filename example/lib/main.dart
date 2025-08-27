import 'package:flutter/material.dart';
import 'package:ios_control_center_slider/ios_control_center_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _currentValue = 5.0;

  void _handleSliderChange(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ios Control Center Slider Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text('Current Value: ${_currentValue.toStringAsFixed(1)}'),
              SizedBox(height: 20),
              IosControlCenterSlider(
                currentValue: 5.0,
                name: 'Volume',
                onChanged: _handleSliderChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
