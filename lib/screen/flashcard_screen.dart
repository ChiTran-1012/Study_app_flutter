import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/word.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Word> words = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('lib/data/words.json');
    final data = json.decode(response) as List;
    setState(() {
      words = data.map((e) => Word.fromJson(e)).toList();
    });
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: Center(
        child: FlashcardWidget(
          word: words[currentIndex].word,
          meaning: words[currentIndex].meaning,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: nextCard,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
