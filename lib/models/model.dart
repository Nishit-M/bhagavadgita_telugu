// import 'dart:convert';

class Verse {
  final String chapterNumber;
  final String verseNumber;
  final String meaning;

  
  Verse({
    required this.chapterNumber,
    required this.verseNumber,
    required this.meaning,

  });
  
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      chapterNumber: json['chapter'].toString(),
      verseNumber: json['verse_number'].toString(),
      meaning: json['meaning'],
    );
  }
}

class Chapter {
  final String number;
  final String name;
  final String summary;
  List<Verse>? verses; // Made nullable
  bool versesLoaded = false;
  
  Chapter({
    required this.number,
    required this.name,
    required this.summary,
    this.verses,
  });
  
  factory Chapter.fromJson(Map<String, dynamic> json, {bool loadVerses = false}) {
    List<Verse>? versesList;
    
    if (loadVerses && json['verses'] != null) {
      versesList = List<Verse>.from(
        json['verses'].map((verse) => Verse.fromJson(verse))
      );
    }
    
    return Chapter(
      number: json['number'].toString(),
      name: json['title'],
      summary: json['subtitle'],
      verses: versesList,
    );
  }
}