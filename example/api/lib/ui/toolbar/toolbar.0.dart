// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:timu_dart/ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Toolbar Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Toolbar(
        direction: ToolbarDirection.horizontal,
        children: <Widget>[
          TextButton(
            child: const Text('BUY TICKETS', style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            )),
            onPressed: () {/* ... */},
          ),
          const SizedBox(width: 8),
          TextButton(
            child: const Text('LISTEN', style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            )),
            onPressed: () {/* ... */},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
