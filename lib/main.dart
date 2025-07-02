import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_directory/screens/downloaded_reports_screen.dart';
import 'package:pdf_directory/bloc/pdf/pdf_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => PdfBloc()..add(LoadPdfFilesEvent()), // Initial load
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DownloadedReportsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
