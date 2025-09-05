import 'package:hive/hive.dart';

class ProgressService {
  static const String boxName = "progressBox";

  /// Lưu điểm quiz
  static Future<void> saveQuizScore(int score) async {
    final box = await Hive.openBox(boxName);
    final currentScore = box.get("quizScore", defaultValue: 0);
    if (score > currentScore) {
      await box.put("quizScore", score); // ✅ chỉ lưu khi điểm cao hơn
    }
  }

  /// Lấy điểm quiz
  static Future<int> loadQuizScore() async {
    final box = await Hive.openBox(boxName);
    return box.get("quizScore", defaultValue: 0);
  }
}
