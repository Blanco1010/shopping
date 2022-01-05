import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String text;

  const LoadingIndicator({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getLoadingIndicator(),
          _getText(text),
        ],
      ),
    );
  }
}

Widget _getLoadingIndicator() {
  return const Padding(
      child: SizedBox(
          child: CircularProgressIndicator(strokeWidth: 3),
          width: 32,
          height: 32),
      padding: EdgeInsets.only(bottom: 16));
}

Widget _getText(String displayedText) {
  return Text(
    displayedText,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    textAlign: TextAlign.center,
  );
}
