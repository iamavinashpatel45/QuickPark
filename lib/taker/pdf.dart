// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:parking/taker/booking_details.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
//
// class pdf extends StatefulWidget {
//   const pdf({Key? key}) : super(key: key);
//
//   @override
//   State<pdf> createState() => _pdfState();
// }
//
// class _pdfState extends State<pdf> {
//   bool display=false;
//   String? path;
//
//   create_pdf()async{
//     var document= PdfDocument();
//     document.pages.add().graphics.drawString(
//         'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         bounds: const Rect.fromLTWH(0, 0, 150, 20));
//     var x= await document.save();
//     File f= new File(booking_details.address!+'.pdf');
//     f.writeAsString(x.toString());
//     path=f.path;
//     setState(() {
//       display=true;
//     });
//   }
//
//   @override
//   void initState() {
//     create_pdf();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: display==false?
//           Center(
//             child: CircularProgressIndicator(),
//           ):
//           PDFView(
//             filePath: path,
//           )
//     );
//   }
// }
