import 'dart:typed_data';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookReader extends StatefulWidget {
  const BookReader({super.key, required this.epubBytes});

  final Uint8List? epubBytes;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();

    _epubController = EpubController(
      // Load document
      document: EpubDocument.openData(widget.epubBytes!),
      // // Set start point
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );

    init();
  }

  Future init() async {
    // ByteData data = await rootBundle.load('assets/metasploit.epub');
    // EpubBook epubBook = await EpubReader.readBook(data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show actual chapter name
        title: EpubViewActualChapter(
            controller: _epubController,
            builder: (chapterValue) => Text(
                  'Chapter: ${chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''}',
                  textAlign: TextAlign.start,
                )),
      ),
      // Show table of contents
      // drawer: Drawer(
      //   child: EpubViewTableOfContents(
      //     controller: _epubController,
      //   ),
      // ),
      body: EpubView(
        controller: _epubController,
      ),
    );
  }
}
