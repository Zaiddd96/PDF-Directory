import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_directory/bloc/pdf/pdf_bloc.dart';
import 'package:pdf_directory/screens/download_pdf_screen.dart';
import 'package:pdf_directory/widgets/pdf_list_item.dart';
import 'package:open_file/open_file.dart';

class DownloadedReportsScreen extends StatefulWidget {
  const DownloadedReportsScreen({super.key});

  @override
  State<DownloadedReportsScreen> createState() => _DownloadedReportsScreenState();
}

class _DownloadedReportsScreenState extends State<DownloadedReportsScreen> {
  final TextEditingController searchController = TextEditingController();

  void openFile(String path) {
    OpenFile.open(path);
  }

  @override
  void initState() {
    super.initState();
    context.read<PdfBloc>().add(LoadPdfFilesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: BlocBuilder<PdfBloc, PdfState>(
          builder: (context, state) {
            if (state is PdfLoaded && state.selectionMode) {
              return Text("${state.selectedPaths.length} Selected",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ));
            }
            return const Text(
              "PDF Directory",
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            );
          },
        ),
        actions: [
          BlocBuilder<PdfBloc, PdfState>(
            builder: (context, state) {
              if (state is PdfLoaded && state.selectionMode) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<PdfBloc>().add(DeleteSelectedEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selected files deleted")),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
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
                  onChanged: (query) => context.read<PdfBloc>().add(SearchPdfEvent(query)),
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
                child: BlocBuilder<PdfBloc, PdfState>(
                  builder: (context, state) {
                    if (state is PdfLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PdfError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.white70)));
                    } else if (state is PdfLoaded) {
                      if (state.visibleFiles.isEmpty) {
                        return ListView(
                          children: const [
                            SizedBox(height: 300),
                            Center(
                              child: Text(
                                "No PDF files found",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async => context.read<PdfBloc>().add(LoadPdfFilesEvent()),
                        child: ListView.builder(
                          itemCount: state.visibleFiles.length,
                          itemBuilder: (context, index) {
                            final pdf = state.visibleFiles[index];
                            final isSelected = state.selectedPaths.contains(pdf.path);
                            return GestureDetector(
                              onLongPress: () => context.read<PdfBloc>().add(ToggleSelectionEvent(pdf.path)),
                              onTap: state.selectionMode
                                  ? () => context.read<PdfBloc>().add(ToggleSelectionEvent(pdf.path))
                                  : () => openFile(pdf.path),
                              child: PdfListItem(
                                pdf: pdf,
                                isSelected: isSelected,
                                onTap: () => openFile(pdf.path),
                                onDelete: () async {
                                  context.read<PdfBloc>().add(ToggleSelectionEvent(pdf.path));
                                  context.read<PdfBloc>().add(DeleteSelectedEvent());
                                },
                                onView: () => openFile(pdf.path),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
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
          context.read<PdfBloc>().add(LoadPdfFilesEvent());
        },
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}
