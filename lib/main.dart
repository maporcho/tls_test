import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class TLSTestScreen extends StatefulWidget {
  @override
  _TLSTestScreenState createState() => _TLSTestScreenState();
}

class _TLSTestScreenState extends State<TLSTestScreen> {
  String _tls12Result = '';
  String _tls13Result = '';

  void _testTLS12() async {
    final client = HttpClient();
    try {
      final req = await client
          .getUrl(Uri.parse('https://browser-test.med.uni-greifswald.de/'));
      final res = await req.close();
      final responseBody = await res.transform(utf8.decoder).join('');
      setState(() {
        if (responseBody.contains('Your browser supports TLS 1.2.')) {
          _tls12Result = 'supported';
        } else {
          _tls12Result = 'not supported';
        }
      });
    } catch (e) {
      setState(() {
        client.close();
        _tls12Result = 'not supported - error: ${e.toString()}';
      });
    }
  }

  void _testTLS13() async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse('https://tls13.1d.pw/'));
      final res = await req.close();
      final responseBody = await res.transform(utf8.decoder).join('');
      setState(() {
        if (responseBody.contains('Successfully connected')) {
          _tls13Result = 'supported';
        } else {
          _tls13Result = 'not supported';
        }
      });
    } catch (e) {
      client.close();
      setState(() {
        _tls13Result = 'not supported - error: ${e.toString()}';
      });
    }
  }

  void _testTLS() {
    _testTLS12();
    _testTLS13();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TLS Test'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testTLS,
              child: Text('Test TLS'),
            ),
            SizedBox(height: 40.0),
            Text(
              'TLS 1.2 Result: $_tls12Result',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'TLS 1.3 Result: $_tls13Result',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TLSTestScreen(),
  ));
}
