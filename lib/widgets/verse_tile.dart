import 'package:flutter/material.dart';

class VerseTile extends StatelessWidget {
  final String verseText;
  const VerseTile({super.key, required this.verseText});

  @override
  Widget build(BuildContext context) {
    String text ;
    String headertext ;
    List<String> lines = verseText.split(' | ');
    if (verseText.contains('ఉవాచ')){
      headertext = lines[0];
      text = lines.sublist(1).join('\n');
    }
    else{
      text = verseText;
      headertext = '';
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber[100]
        ),
        width: double.infinity,
        height: 60,
        // color: Colors.indigo,
        child: Column(
          children: [
            headertext!='' ? Text(headertext) : SizedBox(height: 10,),
            Text(
              textAlign: TextAlign.center,
              text.replaceAll(' | ', '\n'),
              maxLines: 3,
              style: TextStyle(fontSize: 12),
              softWrap: true,
              overflow: TextOverflow.ellipsis, // Ensure visibility
            ),
          ],
        ),
      ),
    );
  }
}
