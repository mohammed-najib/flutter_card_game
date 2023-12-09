import 'package:flutter/material.dart';

import '../widgets/menu.widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crazy Eights'),
        centerTitle: true,
      ),
      body: const MenuWidget(),
    );
  }
}
