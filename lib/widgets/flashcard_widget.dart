import 'package:flutter/material.dart';

class FlashcardWidget extends StatefulWidget {
  final String word;
  final String meaning;

  const FlashcardWidget({super.key, required this.word, required this.meaning});

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool showMeaning = false;

  void toggleCard() {
    setState(() {
      showMeaning = !showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.indigo.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
        ),
        alignment: Alignment.center,
        child: Text(
          showMeaning ? widget.meaning : widget.word,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
