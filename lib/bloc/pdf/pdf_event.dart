part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object?> get props => [];
}

class LoadPdfFilesEvent extends PdfEvent {}

class SearchPdfEvent extends PdfEvent {
  final String query;
  const SearchPdfEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleSelectionEvent extends PdfEvent {
  final String path;
  const ToggleSelectionEvent(this.path);

  @override
  List<Object?> get props => [path];
}

class DeleteSelectedEvent extends PdfEvent {}
