import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';
 
class QuizProvider extends ChangeNotifier {
  String _userName = '';
  String _selectedCategory = 'flutter';
  String _selectedDifficulty = 'Semua';
  int _questionCount = 5;
  int _currentIndex = 0;
  bool _isDarkMode = false;

  final Map<int, int> _userAnswers = {};
  final Map<int, bool> _flaggedQuestions = {};

  int _timeRemaining = 180;
  Timer? _timer;
  List<Question> _activeQuestions = [];
  List<QuizResult> _history = [];
  QuizResult? _lastResult;

  String get userName => _userName;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  int get questionCount => _questionCount;
  int get currentIndex => _currentIndex;
  bool get isDarkMode => _isDarkMode;
  Map<int, int> get userAnswers => _userAnswers;
  Map<int, bool> get flaggedQuestions => _flaggedQuestions;
  int get timeRemaining => _timeRemaining;
  List<Question> get activeQuestions => _activeQuestions;
  List<QuizResult> get history => _history;
  QuizResult? get lastResult => _lastResult;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setQuestionCount(int count) {
    _questionCount = count;
    notifyListeners();
  }

  void startQuiz(List<Question> allQuestions) {
    _timer?.cancel();
    _userAnswers.clear();
    _flaggedQuestions.clear();
    _currentIndex = 0;
    _timeRemaining = _questionCount * 30;

    var filtered = allQuestions.where((q) {
      if (_selectedCategory != 'all' &&
          q.category != _selectedCategory) {
        return false;
      }

      if (_selectedDifficulty != 'Semua' &&
          q.difficulty != _selectedDifficulty) {
        return false;
      }

      return true;
    }).toList();

    if (filtered.isEmpty) {
      filtered = allQuestions.take(_questionCount).toList();
    } else {
      filtered = filtered.take(_questionCount).toList();
    }

    _activeQuestions = filtered;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
      } else {
        timer.cancel();
        submitQuiz();
      }
    });
  }

  void selectAnswer(int questionId, int optionIndex) {
    _userAnswers[questionId] = optionIndex;
    notifyListeners();
  }

  void toggleFlag(int questionId) {
    final current = _flaggedQuestions[questionId] ?? false;
    _flaggedQuestions[questionId] = !current;
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _activeQuestions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentIndex < _activeQuestions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void prevQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  QuizResult submitQuiz() {
    _timer?.cancel();

    int correct = 0;

    for (final question in _activeQuestions) {
      if (_userAnswers[question.id] ==
          question.correctAnswerIndex) {
        correct++;
      }
    }

    final total = _activeQuestions.length;
    final score =
        total > 0 ? ((correct / total) * 100).round() : 0;
    final accuracy =
        total > 0 ? (correct / total) * 100 : 0.0;
    final timeSpent =
        (_questionCount * 30) - _timeRemaining;

    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: _userName.isEmpty ? 'Mahasiswa IKLC' : _userName,
      score: score,
      totalQuestions: total,
      correctCount: correct,
      wrongCount: total - correct,
      timeSpentSeconds: timeSpent > 0 ? timeSpent : 1,
      accuracy: accuracy,
      date: DateTime.now(),
      category: _selectedCategory,
    );

    _lastResult = result;
    _history.insert(0, result);
    _saveHistory();
    notifyListeners();

    return result;
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list =
          _history.map((result) => jsonEncode(result.toJson())).toList();

      await prefs.setStringList('quiz_history', list);
    } catch (_) {}
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('quiz_history');

      if (list != null) {
        _history = list
            .map((item) => QuizResult.fromJson(jsonDecode(item)))
            .toList();

        notifyListeners();
      }
    } catch (_) {}
  }

  void clearHistory() async {
    _history.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_history');

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
