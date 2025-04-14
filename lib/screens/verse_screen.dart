import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// You'll need to add these packages to your pubspec.yaml
// import 'package:just_audio/just_audio.dart';
// import 'package:share_plus/share_plus.dart';

class VerseDetailScreen extends StatefulWidget {
  final String chapterNumber;
  final String chapterTitle;
  final String verseNumber;
  final String verseText;
  final String meaning;

  const VerseDetailScreen({
    super.key,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.verseNumber,
    required this.verseText,
    required this.meaning,
  });

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPlaying = false;
  double playbackProgress = 0.0;
  bool isFavorite = false;
  Timer? _progressTimer;
  

  // Late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize audio player
    //_audioPlayer = AudioPlayer();
    // Here you would set up the audio source from your assets or network
    //_loadAudio();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _progressTimer?.cancel();
    // _audioPlayer.dispose();
    super.dispose();
  }

  // Future<void> _loadAudio() async {
  //   try {
  //     await _audioPlayer.setAsset(
  //       'assets/audio/chapter_${widget.chapterNumber}/verse_${widget.verseNumber}.mp3'
  //     );
  //   } catch (e) {
  //     print('Error loading audio: $e');
  //   }
  // }

  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;

      // Simulate audio playback with a timer
      if (isPlaying) {
        _progressTimer =
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {
            playbackProgress += 0.005;
            if (playbackProgress >= 1.0) {
              playbackProgress = 0.0;
              isPlaying = false;
              timer.cancel();
            }
          });
        });
      } else {
        _progressTimer?.cancel();
      }

      // Actual implementation would use audio player
      // if (isPlaying) {
      //   _audioPlayer.play();
      // } else {
      //   _audioPlayer.pause();
      // }
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareVerse() {
    // Using share_plus package
    // Share.share(
    //   'Bhagavad Gita - Chapter ${widget.chapterNumber}, Verse ${widget.verseNumber}\n\n'
    //   '${widget.verseText}\n\n'
    //   'Meaning: ${widget.meaning}'
    // );

    // Placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Sharing functionality will be implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    int verseIndex = int.parse(widget.verseNumber);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.brown[800]),
        title: Text(
          widget.chapterTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.brown[800],
            ),
            onPressed: _toggleFavorite,
            tooltip: 'Add to Favorites',
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.brown[800]),
            onPressed: _shareVerse,
            tooltip: 'Share Verse',
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
            opacity: 0.2,
            image: AssetImage('./assets/images/Verses.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Verse header
              _buildVerseHeader(screenWidth, screenHeight, isSmallScreen),

              // Audio player
              _buildAudioPlayer(screenWidth, screenHeight, isSmallScreen),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFFFC107),
                  labelColor: Colors.brown[800],
                  unselectedLabelColor: Colors.brown[400],
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.menu_book),
                      text: 'Verse',
                    ),
                    Tab(
                      icon: Icon(Icons.translate),
                      text: 'Meaning',
                    ),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildVerseView(screenWidth, screenHeight, isSmallScreen),
                    _buildMeaningView(screenWidth, screenHeight, isSmallScreen),
                  ],
                ),
              ),

              // Navigation bar
              _buildNavigationBar(screenWidth, screenHeight, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerseHeader(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return Container(
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Chapter ${widget.chapterNumber} · Verse ${widget.verseNumber}',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[700],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.015,
      ),
      color: Colors.white.withOpacity(0.4),
      child: Row(
        children: [
          // Play/pause button
          InkWell(
            onTap: _togglePlayback,
            borderRadius: BorderRadius.circular(30),
            child: Container(
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
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.brown[800],
                size: screenWidth * 0.06,
              ),
            ),
          ),

          // Progress bar
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: playbackProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(
                            Duration(seconds: (playbackProgress * 60).round())),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: Colors.brown[700],
                        ),
                      ),
                      Text(
                        _formatDuration(const Duration(minutes: 1)),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Speed button
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.005,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  '1.0x',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[700],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: screenWidth * 0.05,
                  color: Colors.brown[700],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseView(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'श्लोक / śloka',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: Colors.brown[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  widget.verseText,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    height: 1.6,
                    color: Colors.brown[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.content_copy,
                      label: 'Copy',
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.verseText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Verse copied to clipboard')),
                        );
                      },
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    _buildActionButton(
                      icon: Icons.text_fields,
                      label: 'Transliteration',
                      onTap: () {
                        // Show transliteration
                        _showTransliteration(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'Word by Word',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // Placeholder for word-by-word breakdown
            // You would populate this from your JSON data
            child: Column(
              children: [
                _buildWordItem('धर्मक्षेत्रे', 'in the field of dharma'),
                _buildWordItem('कुरुक्षेत्रे', 'in the field of the Kurus'),
                _buildWordItem('समवेता', 'assembled'),
                _buildWordItem('युयुत्सवः', 'desiring to fight'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningView(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Translation & Commentary',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Translation',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  widget.meaning,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    height: 1.6,
                    color: Colors.brown[900],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Commentary',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Krishna explains to Arjuna the importance of fulfilling one\'s duty (dharma) without attachment to the results. This is the essence of Karma Yoga, where actions are performed with dedication but without concern for personal gain or loss.',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    height: 1.6,
                    color: Colors.brown[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.content_copy,
                      label: 'Copy',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.meaning));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Meaning copied to clipboard')),
                        );
                      },
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    _buildActionButton(
                      icon: Icons.volume_up,
                      label: 'Listen',
                      onTap: _togglePlayback,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'Related Verses',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Placeholder for related verses
          Container(
            height: 120,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                _buildRelatedVerse(context, '2', '47'),
                _buildRelatedVerse(context, '3', '7'),
                _buildRelatedVerse(context, '3', '19'),
                _buildRelatedVerse(context, '5', '7'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous verse button
          TextButton.icon(
            onPressed: () {
              // Navigate to previous verse
              if (int.parse(widget.verseNumber) > 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerseDetailScreen(
                      chapterNumber: widget.chapterNumber,
                      chapterTitle: widget.chapterTitle,
                      verseNumber:
                          (int.parse(widget.verseNumber) - 1).toString(),
                      // You would need to get the previous verse text and meaning
                      verseText: 'Previous verse text',
                      meaning: 'Previous verse meaning',
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: screenWidth * 0.04,
              color: int.parse(widget.verseNumber) > 1
                  ? Colors.brown[700]
                  : Colors.grey[400],
            ),
            label: Text(
              'Previous',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: int.parse(widget.verseNumber) > 1
                    ? Colors.brown[700]
                    : Colors.grey[400],
              ),
            ),
          ),

          // Verse selector
          InkWell(
            onTap: () {
              // Show verse selection dialog
              _showVerseSelector(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7AE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Verse ${widget.verseNumber}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[800],
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: screenWidth * 0.05,
                    color: Colors.brown[800],
                  ),
                ],
              ),
            ),
          ),

          // Next verse button
          TextButton.icon(
            onPressed: () {
              // Navigate to next verse (assuming there are more verses)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerseDetailScreen(
                    chapterNumber: widget.chapterNumber,
                    chapterTitle: widget.chapterTitle,
                    verseNumber: (int.parse(widget.verseNumber) + 1).toString(),
                    // You would need to get the next verse text and meaning
                    verseText: 'Next verse text',
                    meaning: 'Next verse meaning',
                  ),
                ),
              );
            },
            label: Text(
              'Next',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.brown[700],
              ),
            ),
            icon: Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.04,
              color: Colors.brown[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordItem(String sanskrit, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sanskrit,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              meaning,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.brown[700],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.brown[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedVerse(
      BuildContext context, String chapterNum, String verseNum) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerseDetailScreen(
                  chapterNumber: chapterNum,
                  chapterTitle:
                      'Chapter Title', // You would get the actual title
                  verseNumber: verseNum,
                  verseText: 'Related verse text',
                  meaning: 'Related verse meaning',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chapter $chapterNum',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Verse $verseNum',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Related verse preview text...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTransliteration(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sanskrit Transliteration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'karmaṇy evādhikāras te mā phaleṣu kadācana\nmā karma-phala-hetur bhūr mā te saṅgo \'stv akarmaṇi',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.brown[900],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showVerseSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chapter ${widget.chapterNumber} Verses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // Assuming there are 47 verses in the chapter (adjust as needed)
                itemCount: 47,
                itemBuilder: (context, index) {
                  final verseNum = (index + 1).toString();
                  final isSelected = verseNum == widget.verseNumber;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (verseNum != widget.verseNumber) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerseDetailScreen(
                              chapterNumber: widget.chapterNumber,
                              chapterTitle: widget.chapterTitle,
                              verseNumber: verseNum,
                              // You would need to get the verse text and meaning
                              verseText: 'Verse $verseNum text',
                              meaning: 'Verse $verseNum meaning',
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFC107)
                            : const Color(0xFFFFF7AE).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: Colors.brown.shade800, width: 2)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        verseNum,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.brown[900]
                              : Colors.brown[700],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
