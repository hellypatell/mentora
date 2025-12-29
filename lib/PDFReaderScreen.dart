import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFReaderScreen extends StatefulWidget {
  final String pdfPath;

  const PDFReaderScreen({super.key, required this.pdfPath});

  @override
  State<PDFReaderScreen> createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late String _selectedPdf;

  final List<Map<String, String>> _pdfFiles = [
    {"title": "Biology - Standard 11", "path": "assets/data/BIO11.pdf"},
    {"title": "Physics - Standard 11", "path": "assets/data/PHY11.pdf"},
    {"title": "Chemistry - Standard 11", "path": "assets/data/CHEM11.pdf"},
    {"title": "Physics - Standard 12", "path": "assets/data/PHY12.pdf"},
    {"title": "Chemistry - Standard 12", "path": "assets/data/CHEM12.pdf"},
    {"title": "Biology - Standard 12", "path": "assets/data/BIO12.pdf"},
    {"title": "Math - Standard 11", "path": "assets/data/MATH11.pdf"},
    {"title": "Math - Standard 12", "path": "assets/data/MATH12.pdf"},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPdf = widget.pdfPath;
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0D1B2A);
    const Color cardBg = Color(0xFF1B263B);
    const Color accentBlue = Color(0xFF2563EB);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Polished AppBar
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Read PDF',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Dropdown pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: darkBg.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: cardBg,
                          icon: const Icon(Icons.menu_book, color: Colors.white),
                          value: _selectedPdf,
                          items: _pdfFiles.map((pdf) {
                            return DropdownMenuItem<String>(
                              value: pdf["path"],
                              child: Text(
                                pdf["title"]!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPdf = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _actionButton(accentBlue, Icons.zoom_in, () {
                      _pdfController.zoomLevel += 0.25;
                    }),
                    _actionButton(accentBlue, Icons.zoom_out, () {
                      _pdfController.zoomLevel -= 0.25;
                    }),
                    _actionButton(accentBlue, Icons.edit, () {
                      _pdfViewerKey.currentState?.openAnnotationToolbar();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // PDF Viewer
              Expanded(
                child: SfPdfViewer.asset(
                  _selectedPdf,
                  key: _pdfViewerKey,
                  controller: _pdfController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  enableTextSelection: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(Color bgColor, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// Dummy extension
extension on SfPdfViewerState? {
  void openAnnotationToolbar() {}
}
