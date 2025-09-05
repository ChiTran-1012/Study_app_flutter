class Progress {
  int learnedWords;
  int quizScore;

  Progress({this.learnedWords = 0, this.quizScore = 0});

  Map<String, dynamic> toJson() => {
    'learnedWords': learnedWords,
    'quizScore': quizScore,
  };

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      learnedWords: json['learnedWords'] ?? 0,
      quizScore: json['quizScore'] ?? 0,
    );
  }
}
