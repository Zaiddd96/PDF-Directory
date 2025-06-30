import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_directory/models/pdf_file_model.dart';
import 'package:pdf_directory/screens/download_pdf_screen.dart';
import '../widgets/pdf_list_item.dart';

class DownloadedReportsScreen extends StatefulWidget {
  const DownloadedReportsScreen({super.key});

  @override
  State<DownloadedReportsScreen> createState() =>
      _DownloadedReportsScreenState();
}

class _DownloadedReportsScreenState extends State<DownloadedReportsScreen> {
  List<PdfFileModel> allFiles = [];
  List<PdfFileModel> files = [];
  final TextEditingController searchController = TextEditingController();

  bool selectionMode = false;
  Set<String> selectedPaths = {};

  void openFile(String path) {
    OpenFile.open(path);
  }

  Future<void> loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final filesInDir = dir.listSync();

    final pdfs = filesInDir
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) {
      final stat = file.statSync();
      return PdfFileModel(
        name: file.uri.pathSegments.last,
        size: stat.size,
        path: file.path,
        modifiedAt: stat.modified,
      );
    }).toList();

    setState(() {
      allFiles = pdfs;
      files = pdfs;
      selectionMode = false;
      selectedPaths.clear();
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() => files = allFiles);
    } else {
      final filtered = allFiles
          .where((pdf) =>
          pdf.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() => files = filtered);
    }
  }

  void toggleSelection(String path) {
    setState(() {
      if (selectedPaths.contains(path)) {
        selectedPaths.remove(path);
        if (selectedPaths.isEmpty) selectionMode = false;
      } else {
        selectedPaths.add(path);
        selectionMode = true;
      }
    });
  }

  Future<void> deleteSelectedFiles() async {
    for (final path in selectedPaths) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    setState(() {
      files.removeWhere((pdf) => selectedPaths.contains(pdf.path));
      allFiles.removeWhere((pdf) => selectedPaths.contains(pdf.path));
      selectedPaths.clear();
      selectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Selected files deleted")),
    );
  }

  @override
  void initState() {
    super.initState();
    loadPdfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          selectionMode
              ? "${selectedPaths.length} Selected"
              : "PDF Directory",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: selectionMode
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteSelectedFiles,
          )
        ]
            : [],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1F1F), Color(0xFF0D1A1F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 26),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search PDFs...",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: loadPdfFiles,
                  child: files.isEmpty
                      ? ListView(
                    children: const [
                      SizedBox(height: 300),
                      Center(
                        child: Text(
                          "No PDF files found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final pdf = files[index];
                      final isSelected = selectedPaths.contains(pdf.path);
                      return GestureDetector(
                        onLongPress: () => toggleSelection(pdf.path),
                        onTap: selectionMode
                            ? () => toggleSelection(pdf.path)
                            : () => openFile(pdf.path),
                        child: PdfListItem(
                          pdf: pdf,
                          isSelected: isSelected,
                          onTap: () => openFile(pdf.path),
                          onDelete: () async {
                            toggleSelection(pdf.path);
                            await deleteSelectedFiles();
                          },
                          onView: () => openFile(pdf.path),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DownloadPdfScreen(),
            ),
          );
          loadPdfFiles();
        },
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}
