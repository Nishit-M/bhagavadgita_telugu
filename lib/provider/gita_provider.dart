import 'dart:convert';
import 'package:bhagavadgita_telugu/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class GitaProvider extends ChangeNotifier {
  List<Chapter> _chapters = [];
  bool _isLoaded = false;
  Map<String, Chapter> _loadedChapters = {}; // Cache for loaded chapters
  
  List<Chapter> get chapters => _chapters;
  bool get isLoaded => _isLoaded;
  
  // Initialize with chapter metadata only (not verses)
  Future<void> loadChaptersList() async {
    if (_isLoaded) return;
    
    try {
      // Load chapter metadata from JSON
      final String response = await rootBundle.loadString('./assets/data/chapter_data.json');
      final data = await json.decode(response);
      
      _chapters = List<Chapter>.from(
        data['chapters'].map((chapter) => Chapter.fromJson(chapter, loadVerses: false))
      );
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error loading Gita chapters metadata: $e');
    }
  }
  
  // Load a specific chapter with its verses
  Future<Chapter?> loadChapter(String chapterNumber) async {
    // Check if already loaded
    if (_loadedChapters.containsKey(chapterNumber)) {
      return _loadedChapters[chapterNumber];
    }
    
    try {
      // Load specific chapter data from JSON
      final String response = await rootBundle.loadString('./assets/data/chapter_$chapterNumber.json');
      final data = await json.decode(response);
      print('data:$data');
      
      final chapter = Chapter.fromJson(data, loadVerses: true);
      chapter.versesLoaded = true;
      
      // Update the chapter in the list
      final index = _chapters.indexWhere((ch) => ch.number == chapterNumber);
      if (index >= 0) {
        _chapters[index] = chapter;
      }
      
      // Cache the loaded chapter
      _loadedChapters[chapterNumber] = chapter;
      
      notifyListeners();
      return chapter;
    } catch (e) {
      print('Error loading Chapter $chapterNumber: $e');
      return null;
    }
  }
  
  Chapter? getChapter(String chapterNumber) {
    try {
      return _chapters.firstWhere((chapter) => chapter.number == chapterNumber);
    } catch (e) {
      return null;
    }
  }
  
  Future<Verse?> getVerse(String chapterNumber, String verseNumber) async {
    // Ensure chapter is loaded
    Chapter? chapter = await ensureChapterLoaded(chapterNumber);
    if (chapter == null || chapter.verses == null) return null;
    
    try {
      return chapter.verses!.firstWhere((verse) => verse.verseNumber == verseNumber);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> hasVerse(String chapterNumber, String verseNumber) async {
    Chapter? chapter = await ensureChapterLoaded(chapterNumber);
    if (chapter == null || chapter.verses == null) return false;
    
    try {
      chapter.verses!.firstWhere((verse) => verse.verseNumber == verseNumber);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<int> getVerseCount(String chapterNumber) async {
    Chapter? chapter = await ensureChapterLoaded(chapterNumber);
    return chapter?.verses?.length ?? 0;
  }
  
  Future<Verse?> getNextVerse(String chapterNumber, String verseNumber) async {
    Chapter? chapter = await ensureChapterLoaded(chapterNumber);
    if (chapter == null || chapter.verses == null) return null;
    
    try {
      int currentIndex = chapter.verses!.indexWhere(
        (verse) => verse.verseNumber == verseNumber
      );
      
      if (currentIndex < 0 || currentIndex >= chapter.verses!.length - 1) {
        return null;
      }
      
      return chapter.verses![currentIndex + 1];
    } catch (e) {
      return null;
    }
  }
  
  Future<Verse?> getPreviousVerse(String chapterNumber, String verseNumber) async {
    Chapter? chapter = await ensureChapterLoaded(chapterNumber);
    if (chapter == null || chapter.verses == null) return null;
    
    try {
      int currentIndex = chapter.verses!.indexWhere(
        (verse) => verse.verseNumber == verseNumber
      );
      
      if (currentIndex <= 0) {
        return null;
      }
      
      return chapter.verses![currentIndex - 1];
    } catch (e) {
      return null;
    }
  }
  
  // Helper method to ensure a chapter is loaded
  Future<Chapter?> ensureChapterLoaded(String chapterNumber) async {
    Chapter? chapter = getChapter(chapterNumber);
    
    // If chapter exists but verses aren't loaded, load them
    if (chapter != null && !chapter.versesLoaded) {
      return await loadChapter(chapterNumber);
    }
    
    return chapter;
  }
  
  // Clear cached chapters to free memory (call when navigating away)
  void clearChapterCache() {
    _loadedChapters.clear();
    // Keep chapter metadata but clear verse data
    for (var chapter in _chapters) {
      chapter.verses = null;
      chapter.versesLoaded = false;
    }
    notifyListeners();
  }
  
  // Keep only specified chapter in cache, clear others
  void keepOnlyChapter(String chapterNumber) {
    var chaptersToRemove = Map<String, Chapter>.from(_loadedChapters);
    chaptersToRemove.remove(chapterNumber);
    
    for (var key in chaptersToRemove.keys) {
      final index = _chapters.indexWhere((ch) => ch.number == key);
      if (index >= 0) {
        _chapters[index].verses = null;
        _chapters[index].versesLoaded = false;
      }
      _loadedChapters.remove(key);
    }
    
    notifyListeners();
  }
}