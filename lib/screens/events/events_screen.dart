import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/navigation_controls.dart';
import 'package:flutter_social/widgets/webview_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Event'),
        centerTitle: true,
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(controller: controller),
    );
  }
}
