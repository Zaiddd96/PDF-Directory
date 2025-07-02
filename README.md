# 📁 PDF Directory

PDF Directory is a beautifully designed Flutter application that helps users manage their downloaded PDF files. It provides an intuitive interface to **view**, **search**, **delete**, and **multi-select** PDF documents stored locally on the device. The app also includes functionality to **download** PDFs using URLs.

---

## 📱 Features

- 🎯 **Automatic PDF Discovery**: Scans app document directory for all `.pdf` files.
- 🔍 **Real-time Search**: Filter your PDF list with a live search bar.
- 👁️ **PDF Viewer Integration**: Open PDFs instantly from the list.
- 🗑️ **Delete PDFs**: Remove individual PDFs via long-press or context menu.
- ✅ **Multi-Select Mode**: Select multiple PDFs and delete them at once.
- ⬇️ **Download from URL**: Enter a URL to download and store PDFs directly into the app.
- 🌙 **Dark Theme UI**: Uses a stylish glassmorphic dark UI design for a modern look.
- 📦 **Responsive UI**: Designed to work well on both phones and tablets.

---

## 📦 Packages Used

| Package Name        | Purpose                                                |
|---------------------|--------------------------------------------------------|
| `path_provider`     | To access the app's documents directory.               |
| `open_file`         | To open PDF files with the default external viewer.    |
| `flutter`           | Core framework for building the app.                   |

> All packages are open-source and available on [pub.dev](https://pub.dev).

---

## 🔧 Functionality Breakdown

### 1. **PDF Discovery**
- On app launch, the app lists all `.pdf` files found in the app’s document directory using `path_provider`.

### 2. **PDF List Display**
- A glass-like blurred card UI (`BackdropFilter`) is used for each PDF item.
- Displays name, size, last modified date, and a popup menu.

### 3. **Search Bar**
- Real-time text input filters files by name using `onChanged`.

### 4. **Open PDFs**
- Tapping on an item opens it using the `open_file` plugin.

### 5. **Delete PDFs**
- Long-pressing enables multi-select mode.
- 3-dot popup per file includes View & Delete.
- Confirmation dialog is shown before deleting a file.

### 6. **Multi-Select & Bulk Delete**
- Hold on a PDF to enter selection mode.
- Tap multiple files.
- Tap delete icon in AppBar to remove all selected files.

### 7. **Download via URL**
- Floating action button opens the download screen.
- User can paste a direct URL to a PDF file and download it into the directory.

---

## 🖼️ UI Design

- Gradient background with dark tones.
- All components have rounded corners and soft opacity.
- Uses Material 3 design principles for consistency and clarity.
- Glassmorphism card style using `BackdropFilter` and `LinearGradient`.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Dart >= 3.0.0
- Android/iOS emulator or device

### Installation
```bash
git clone https://github.com/your-username/pdf-directory.git
cd pdf-directory
flutter pub get
flutter run
