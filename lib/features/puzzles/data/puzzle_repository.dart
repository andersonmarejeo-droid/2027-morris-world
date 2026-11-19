import 'package:shared_preferences/shared_preferences.dart';

class PuzzleRepository {
  static const _solvedKey = 'morris_puzzles_solved_ids';

  Future<Set<String>> getSolvedPuzzleIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_solvedKey) ?? <String>[];
    return list.toSet();
  }

  Future<void> markPuzzleSolved(String puzzleId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = (prefs.getStringList(_solvedKey) ?? <String>[]).toSet();
    list.add(puzzleId);
    await prefs.setStringList(_solvedKey, list.toList());
  }

  Future<bool> isPuzzleSolved(String puzzleId) async {
    final solved = await getSolvedPuzzleIds();
    return solved.contains(puzzleId);
  }
}
