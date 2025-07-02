part of 'pdf_bloc.dart';

abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object?> get props => [];
}

class PdfInitial extends PdfState {}

class PdfLoading extends PdfState {}

class PdfError extends PdfState {
  final String message;

  const PdfError(this.message);

  @override
  List<Object?> get props => [message];
}

class PdfLoaded extends PdfState {
  final List<PdfFileModel> allFiles;
  final List<PdfFileModel> visibleFiles;
  final Set<String> selectedPaths;
  final bool selectionMode;

  const PdfLoaded({
    required this.allFiles,
    required this.visibleFiles,
    required this.selectedPaths,
    required this.selectionMode,
  });

  PdfLoaded copyWith({
    List<PdfFileModel>? allFiles,
    List<PdfFileModel>? visibleFiles,
    Set<String>? selectedPaths,
    bool? selectionMode,
  }) {
    return PdfLoaded(
      allFiles: allFiles ?? this.allFiles,
      visibleFiles: visibleFiles ?? this.visibleFiles,
      selectedPaths: selectedPaths ?? this.selectedPaths,
      selectionMode: selectionMode ?? this.selectionMode,
    );
  }

  @override
  List<Object?> get props => [allFiles, visibleFiles, selectedPaths, selectionMode];
}
