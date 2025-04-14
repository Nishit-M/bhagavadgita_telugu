// import 'package:bhagavadgita_telugu/screens/verse_screen.dart';
// import 'package:flutter/material.dart';

// class chapterTile extends StatelessWidget {
//   final String chapterName;
//   final String chapterNumber;
//   const chapterTile(
//       {super.key, required this.chapterName, required this.chapterNumber});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () {
//         print(chapterNumber);
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (ctx) => VerseScreen(verseNumber: chapterNumber)));
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           height: 50,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(width: 20),
//               Text(chapterNumber.toString()),
//               const SizedBox(width: 20),
//               Text(chapterName)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
