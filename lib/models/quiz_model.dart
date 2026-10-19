
class Question {
  final int id;
  final String question;
  final String? codeSnippet;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String category;
  final String difficulty;

  const Question({
    required this.id,
    required this.question,
    this.codeSnippet,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'codeSnippet': codeSnippet,
        'options': options,
        'correctAnswerIndex': correctAnswerIndex,
        'explanation': explanation,
        'category': category,
        'difficulty': difficulty,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as int,
        question: json['question'] as String,
        codeSnippet: json['codeSnippet'] as String?,
        options: List<String>.from(json['options'] as List),
        correctAnswerIndex: json['correctAnswerIndex'] as int,
        explanation: json['explanation'] as String,
        category: json['category'] as String,
        difficulty: json['difficulty'] as String,
      );
}

class QuizResult {
  final String id;
  final String userName;
  final int score;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int timeSpentSeconds;
  final double accuracy;
  final DateTime date;
  final String category;

  const QuizResult({
    required this.id,
    required this.userName,
    required this.score,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.timeSpentSeconds,
    required this.accuracy,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctCount': correctCount,
        'wrongCount': wrongCount,
        'timeSpentSeconds': timeSpentSeconds,
        'accuracy': accuracy,
        'date': date.toIso8601String(),
        'category': category,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        id: json['id'] as String,
        userName: json['userName'] as String,
        score: json['score'] as int,
        totalQuestions: json['totalQuestions'] as int,
        correctCount: json['correctCount'] as int,
        wrongCount: json['wrongCount'] as int,
        timeSpentSeconds: json['timeSpentSeconds'] as int,
        accuracy: (json['accuracy'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        category: json['category'] as String,
      );
}
