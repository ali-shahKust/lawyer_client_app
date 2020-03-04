import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class Pdf_viewer extends StatefulWidget {

  String myUrl;


  Pdf_viewer({this.myUrl});


  @override
  _Pdf_viewerState createState() => _Pdf_viewerState();

}
bool isReady ;
var pages ;
var _controller;

class _Pdf_viewerState extends State<Pdf_viewer> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PDFView(
        filePath: widget.myUrl,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {
          setState(() {
            pages = _pages;
            isReady = true;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int page, int total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
