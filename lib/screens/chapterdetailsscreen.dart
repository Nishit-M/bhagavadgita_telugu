import 'dart:convert';
import 'package:bhagavadgita_telugu/screens/verse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChapterDetailScreen extends StatefulWidget {
  final String chapterNumber;
  final String chapterTitle;
  final String? chapterSubtitle;

  const ChapterDetailScreen({
    Key? key,
    required this.chapterNumber,
    required this.chapterTitle,
    this.chapterSubtitle,
  }) : super(key: key);

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;
  String? chapterIntro;

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      // Load chapter data from JSON file
      // You should organize your JSON files in a structured way, like:
      // assets/chapters/chapter_1.json, assets/chapters/chapter_2.json, etc.
      final String response = await rootBundle
          .loadString('assets/data/chapter_${widget.chapterNumber}.json');
      final data = await json.decode(response);

      setState(() {
        // Assuming your JSON structure has a 'verses' array and 'introduction' field
        verses = List<Map<String, dynamic>>.from(data['verses']);
        chapterIntro = data['summary'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        // In case of error, display empty state with error handling
        isLoading = false;
      });
      print('Error loading chapter data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final bool isSmallScreen = screenWidth < 360;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.brown[800]),
        title: Text(
          widget.chapterTitle,
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 22,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 2.0,
                color: Colors.amber.withOpacity(0.4),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showChapterInfo(context);
            },
            tooltip: 'Chapter Information',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Implement bookmark functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chapter bookmarked!')),
              );
            },
            tooltip: 'Bookmark Chapter',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF7AE).withOpacity(0.8),
              const Color(0xFFFFF1D0).withOpacity(0.9),
            ],
          ),
          image: const DecorationImage(
            opacity: 0.15,
            image: AssetImage('./assets/images/Verses.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? _buildLoadingState()
              : verses.isEmpty
                  ? _buildEmptyState()
                  : _buildVersesList(screenWidth, screenHeight, isSmallScreen),
        ),
      ),
      // FAB for quick actions
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        elevation: 4,
        child: const Icon(Icons.play_arrow, color: Colors.brown),
        onPressed: () {
          // Play chapter audio or start continuous reading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Playing chapter audio...')),
          );
        },
        tooltip: 'Play Chapter Audio',
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFCD853F),
          ),
          SizedBox(height: 16),
          Text(
            'Loading verses...',
            style: TextStyle(
              color: Color(0xFF8B4513),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 72,
            color: Colors.brown[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No verses available for this chapter',
            style: TextStyle(
              color: Colors.brown[800],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.brown[800],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadVerses();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVersesList(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return Column(
      children: [
        // Chapter header and description
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.chapterNumber.toString(),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chapterTitle,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                        if (widget.chapterSubtitle != null)
                          Text(
                            widget.chapterSubtitle!,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.brown[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${verses.length} Verses',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[700],
                    ),
                  ),
                ],
              ),
              if (chapterIntro != null && chapterIntro!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Text(
                    chapterIntro!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.brown[600],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showChapterInfo(context);
                    },
                    child: Text(
                      'Read More',
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        // Verses list title
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.01,
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_stories,
                size: screenWidth * 0.05,
                color: Colors.brown[700],
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                'Verses',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: 'All',
                icon: Icon(Icons.filter_list, color: Colors.brown[700]),
                underline: Container(height: 0),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Verses')),
                  DropdownMenuItem(
                      value: 'Bookmarked', child: Text('Bookmarked')),
                  DropdownMenuItem(
                      value: 'Important', child: Text('Important')),
                ],
                onChanged: (String? newValue) {
                  // Implement filter logic
                },
                style: TextStyle(
                  color: Colors.brown[700],
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
        ),

        // Verses list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              final verseNumber = (index + 1).toString();
              // print('Verse ${verse.runtimeType}');
              // print('Verse1 ${verse}');
              // print('VerseNumber ${verseNumber.runtimeType}');
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white.withOpacity(0.8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.amber.withOpacity(0.3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerseDetailScreen(
                            chapterNumber: widget.chapterNumber.toString(),
                            chapterTitle: widget.chapterTitle,
                            verseNumber: verseNumber,
                            verseText: verse['text']
                                .toString(), // ✅ not verse['verse']!
                            meaning: verse['meaning'].toString(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.004,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFC107),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  verseNumber,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[800],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.volume_up_outlined,
                                size: screenWidth * 0.05,
                                color: Colors.brown[400],
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Icon(
                                Icons.bookmark_border,
                                size: screenWidth * 0.05,
                                color: Colors.brown[400],
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            verse['text'],
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              height: 1.5,
                              color: Colors.brown[900],
                              fontFamily:
                                  'NotoSansTelugu', // Use appropriate Telugu font
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward,
                              size: screenWidth * 0.05,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showChapterInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapter ${widget.chapterNumber}: ${widget.chapterTitle}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    if (widget.chapterSubtitle != null)
                      Text(
                        widget.chapterSubtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.brown[600],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      chapterIntro ?? 'No chapter information available.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.brown[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Key Themes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Placeholder for key themes
                    // You would populate this from your JSON data
                    _buildThemeChip('Dharma'),
                    _buildThemeChip('Karma Yoga'),
                    _buildThemeChip('Devotion'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xFFFFF7AE),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

