import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/pdf_file_model.dart';

class PdfListItem extends StatelessWidget {
  final PdfFileModel pdf;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const PdfListItem({
    Key? key,
    required this.pdf,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.onView,
    this.onDelete,
  }) : super(key: key);

  String formatBytes(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    if (bytes >= mb) return "${(bytes / mb).toStringAsFixed(2)} MB";
    return "${(bytes / kb).toStringAsFixed(2)} KB";
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} • ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                onTap: onTap,
                onLongPress: onLongPress,
                leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                title: Text(
                  pdf.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "${formatBytes(pdf.size)} • ${formatDate(pdf.modifiedAt)}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: const Color(0xFF1F1F1F),
                  onSelected: (value) {
                    if (value == 'view' && onView != null) {
                      onView!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text("View", style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 28,
            right: 22,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }
}
