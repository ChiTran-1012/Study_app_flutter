import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> questions = [];
  late QuizQuestion currentQuestion;
  String feedback = "";
  int score = 0; // ✅ khai báo điểm hiện tại

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('lib/data/test.json');
    final data = json.decode(response) as List;
    setState(() {
      questions = data.map((e) => QuizQuestion.fromJson(e)).toList();
      generateQuestion();
    });
  }

  void generateQuestion() {
    if (questions.isEmpty) return;
    final random = Random();
    currentQuestion = questions[random.nextInt(questions.length)];
    feedback = "";
  }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == currentQuestion.answer) {
        feedback = "✅ Correct!";
        score++; // ✅ tăng điểm khi đúng
      } else {
        feedback = "❌ Wrong!";
        score--; // ✅ giảm điểm khi sai
        if (score < 0) score = 0; // ✅ điểm không âm
      }
    });
  }

  void nextQuestion() {
    setState(() {
      generateQuestion();
    });
  }

  Future<void> endQuiz() async {
    await ProgressService.saveQuizScore(score); // ✅ lưu điểm
    setState(() {
      score = 0; // reset để chơi lại từ đầu
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Progress saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.map(
              (opt) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(opt),
                  child: Text(opt),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                feedback,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: feedback.contains("Correct")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: nextQuestion,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Next Question"),
                ),
                ElevatedButton.icon(
                  onPressed: endQuiz,
                  icon: const Icon(Icons.check),
                  label: const Text("End Quiz"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
