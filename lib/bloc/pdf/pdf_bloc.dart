import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/pdf_file_model.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfInitial()) {
    on<LoadPdfFilesEvent>(_onLoadPdfFiles);
    on<SearchPdfEvent>(_onSearch);
    on<ToggleSelectionEvent>(_onToggleSelection);
    on<DeleteSelectedEvent>(_onDeleteSelected);
  }

  Future<void> _onLoadPdfFiles(
      LoadPdfFilesEvent event, Emitter<PdfState> emit) async {
    emit(PdfLoading());
    try {
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

      emit(PdfLoaded(
        allFiles: pdfs,
        visibleFiles: pdfs,
        selectedPaths: {},
        selectionMode: false,
      ));
    } catch (_) {
      emit(PdfError("Failed to load PDF files"));
    }
  }

  void _onSearch(SearchPdfEvent event, Emitter<PdfState> emit) {
    if (state is PdfLoaded) {
      final current = state as PdfLoaded;
      final filtered = event.query.isEmpty
          ? current.allFiles
          : current.allFiles
          .where((pdf) =>
          pdf.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(current.copyWith(visibleFiles: filtered));
    }
  }

  Future<void> _onToggleSelection(
      ToggleSelectionEvent event, Emitter<PdfState> emit) async {
    if (state is PdfLoaded) {
      final current = state as PdfLoaded;
      final updated = Set<String>.from(current.selectedPaths);
      if (updated.contains(event.path)) {
        updated.remove(event.path);
      } else {
        updated.add(event.path);
      }
      emit(current.copyWith(
        selectedPaths: updated,
        selectionMode: updated.isNotEmpty,
      ));
    }
  }

  Future<void> _onDeleteSelected(
      DeleteSelectedEvent event, Emitter<PdfState> emit) async {
    if (state is PdfLoaded) {
      final current = state as PdfLoaded;
      final updatedAll = List<PdfFileModel>.from(current.allFiles);
      final updatedVisible = List<PdfFileModel>.from(current.visibleFiles);
      for (final path in current.selectedPaths) {
        final file = File(path);
        if (await file.exists()) await file.delete();
        updatedAll.removeWhere((pdf) => pdf.path == path);
        updatedVisible.removeWhere((pdf) => pdf.path == path);
      }
      emit(current.copyWith(
        allFiles: updatedAll,
        visibleFiles: updatedVisible,
        selectedPaths: {},
        selectionMode: false,
      ));
    }
  }
}
