import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// ─── PASTE YOUR OCR.SPACE FREE API KEY HERE ──────────────────────────────────
// Get free key at: https://ocr.space/ocrapi/freekey (just enter your email)
const String _kApiKey = 'K88506009588957';
// ─────────────────────────────────────────────────────────────────────────────

class KhmerOcrPage extends StatefulWidget {
  const KhmerOcrPage({super.key});

  @override
  State<KhmerOcrPage> createState() => _KhmerOcrPageState();
}

class _KhmerOcrPageState extends State<KhmerOcrPage> {
  String _extractedText = '';
  File? _pickedImage;
  bool _isProcessing = false;
  String _statusMessage = '';
  bool _copied = false;

  final _picker = ImagePicker();

  // ─── Pick & OCR ────────────────────────────────────────────────────────────
  Future<void> _pickAndOcr(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (picked == null) return;

      setState(() {
        _isProcessing = true;
        _extractedText = '';
        _statusMessage = 'Uploading image…';
        _pickedImage = File(picked.path);
        _copied = false;
      });

      final result = await _callOcrSpace(picked.path);

      setState(() {
        _extractedText = result.trim().isEmpty
            ? '⚠️ No text detected.\nTry a clearer image or better lighting.'
            : result.trim();
        _isProcessing = false;
        _statusMessage = result.trim().isEmpty
            ? 'No text found'
            : 'Done — ${result.trim().split(RegExp(r'\s+')).length} words extracted';
      });
    } catch (e) {
      print('❌ OCR failed.\n\n${e.toString()}');
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Error: ${e.toString()}';
        _extractedText = '❌ OCR failed.\n\n${e.toString()}';
      });
    }
  }

  // ─── OCR.space API ─────────────────────────────────────────────────────────
  Future<String> _callOcrSpace(String imagePath) async {
    _setStatus('Uploading to OCR.space…');

    final url = Uri.parse('https://api.ocr.space/parse/image');

    // Send as multipart form
    final request = http.MultipartRequest('POST', url)
      ..fields['apikey'] = _kApiKey
      ..fields['language'] =
          'khm' // Khmer language code
      ..fields['isOverlayRequired'] = 'false'
      ..fields['detectOrientation'] = 'true'
      ..fields['scale'] =
          'true' // auto-scale for better accuracy
      ..fields['OCREngine'] =
          '2' // Engine 2 is more accurate for non-Latin
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    _setStatus('Processing OCR…');
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception(
        'OCR.space error ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // Check for API error
    final isError = json['IsErroredOnProcessing'] as bool? ?? false;
    if (isError) {
      final errorMsg = json['ErrorMessage'];
      throw Exception('OCR.space: $errorMsg');
    }

    // Extract text from all parsed results
    final parsedResults = json['ParsedResults'] as List<dynamic>?;
    if (parsedResults == null || parsedResults.isEmpty) return '';

    final buffer = StringBuffer();
    for (final item in parsedResults) {
      final text = (item as Map<String, dynamic>)['ParsedText'] as String?;
      if (text != null && text.trim().isNotEmpty) {
        buffer.write(text);
      }
    }

    return buffer.toString();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  void _setStatus(String msg) {
    if (mounted) setState(() => _statusMessage = msg);
  }

  Future<void> _copyText() async {
    if (_extractedText.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _extractedText));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  void _clear() => setState(() {
    _extractedText = '';
    _pickedImage = null;
    _statusMessage = '';
    _copied = false;
  });

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.document_scanner_rounded, color: cs.primary, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Khmer OCR Scanner',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        actions: [
          if (_extractedText.isNotEmpty || _pickedImage != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Clear',
              onPressed: _clear,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildImagePreview(cs),
            _buildActionButtons(cs),
            if (_statusMessage.isNotEmpty) _buildStatusBar(cs),
            Expanded(child: _buildTextResult(cs, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(ColorScheme cs) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _pickedImage != null ? 220 : 160,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isProcessing ? cs.primary : cs.outlineVariant,
          width: _isProcessing ? 2.0 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _pickedImage != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.file(_pickedImage!, fit: BoxFit.cover),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: cs.primary,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_search_rounded,
                  size: 48,
                  color: cs.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pick or capture an image to begin',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButtons(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: _isProcessing
                  ? null
                  : () => _pickAndOcr(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_rounded, size: 18),
              label: const Text('Camera'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: _isProcessing
                  ? null
                  : () => _pickAndOcr(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_rounded, size: 18),
              label: const Text('Gallery'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isProcessing
            ? cs.primaryContainer
            : cs.secondaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (_isProcessing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.onPrimaryContainer,
              ),
            )
          else
            Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: cs.onSecondaryContainer,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 12,
                color: _isProcessing
                    ? cs.onPrimaryContainer
                    : cs.onSecondaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextResult(ColorScheme cs, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.text_snippet_outlined,
                  size: 16,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Extracted Text',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (_extractedText.isNotEmpty)
                  GestureDetector(
                    onTap: _copyText,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _copied
                          ? Row(
                              key: const ValueKey('copied'),
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Copied!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              key: const ValueKey('copy'),
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: cs.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Copy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _extractedText.isEmpty
                ? Center(
                    child: Text(
                      _isProcessing
                          ? 'Reading text…'
                          : 'Extracted text will appear here',
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.35),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: SelectableText(
                        _extractedText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          fontSize: 14,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

//==========================withg cloud api

// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// // ─── PASTE YOUR GOOGLE CLOUD VISION API KEY HERE ─────────────────────────────
// const String _kApiKey = 'AIzaSyB2jAr3Nag-0UV_mogeB2Pp-EYOdabOeBM';
// // ─────────────────────────────────────────────────────────────────────────────

// class KhmerOcrPage extends StatefulWidget {
//   const KhmerOcrPage({super.key});

//   @override
//   State<KhmerOcrPage> createState() => _KhmerOcrPageState();
// }

// class _KhmerOcrPageState extends State<KhmerOcrPage> {
//   String _extractedText = '';
//   File? _pickedImage;
//   bool _isProcessing = false;
//   String _statusMessage = '';
//   bool _copied = false;

//   final _picker = ImagePicker();

//   // ─── Pick & OCR ────────────────────────────────────────────────────────────
//   Future<void> _pickAndOcr(ImageSource source) async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: source,
//         imageQuality: 100,
//         preferredCameraDevice: CameraDevice.rear,
//       );
//       if (picked == null) return;

//       setState(() {
//         _isProcessing = true;
//         _extractedText = '';
//         _statusMessage = 'Uploading image…';
//         _pickedImage = File(picked.path);
//         _copied = false;
//       });

//       final result = await _callVisionApi(picked.path);

//       setState(() {
//         _extractedText = result.trim().isEmpty
//             ? '⚠️ No text detected.\nTry a clearer image or better lighting.'
//             : result.trim();
//         _isProcessing = false;
//         _statusMessage = result.trim().isEmpty
//             ? 'No text found'
//             : 'Done — ${result.trim().split(RegExp(r'\s+')).length} words extracted';
//       });
//     } catch (e) {
//       setState(() {
//         _isProcessing = false;
//         _statusMessage = 'Error: ${e.toString()}';
//         _extractedText = '❌ OCR failed.\n\n${e.toString()}';
//       });
//     }
//   }

//   // ─── Google Cloud Vision API ───────────────────────────────────────────────
//   Future<String> _callVisionApi(String imagePath) async {
//     _setStatus('Encoding image…');

//     // Read & base64-encode the image
//     final bytes = await File(imagePath).readAsBytes();
//     final base64Image = base64Encode(bytes);

//     _setStatus('Calling Vision API…');

//     final url = Uri.parse(
//       'https://vision.googleapis.com/v1/images:annotate?key=$_kApiKey',
//     );

//     final requestBody = jsonEncode({
//       'requests': [
//         {
//           'image': {'content': base64Image},
//           'features': [
//             {
//               // DOCUMENT_TEXT_DETECTION is better for dense/multi-line text
//               'type': 'DOCUMENT_TEXT_DETECTION',
//               'maxResults': 1,
//             },
//           ],
//           'imageContext': {
//             // Hint Vision API to prioritise Khmer + English
//             'languageHints': ['km', 'en'],
//           },
//         },
//       ],
//     });

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: requestBody,
//     );

//     if (response.statusCode != 200) {
//       print('Vision API error ${response.statusCode}: ${response.body}');
//       throw Exception(
//         'Vision API error ${response.statusCode}: ${response.body}',
//       );
//     }

//     final json = jsonDecode(response.body) as Map<String, dynamic>;

//     // Check for API-level errors
//     final responses = json['responses'] as List<dynamic>;
//     if (responses.isEmpty) return '';

//     final first = responses[0] as Map<String, dynamic>;
//     if (first.containsKey('error')) {
//       final err = first['error'] as Map<String, dynamic>;
//       throw Exception('Vision API: ${err['message']}');
//     }

//     // DOCUMENT_TEXT_DETECTION → fullTextAnnotation → text
//     final fullText = first['fullTextAnnotation'] as Map<String, dynamic>?;
//     if (fullText != null) {
//       return fullText['text'] as String? ?? '';
//     }

//     // Fallback: TEXT_DETECTION → textAnnotations[0].description
//     final annotations = first['textAnnotations'] as List<dynamic>?;
//     if (annotations != null && annotations.isNotEmpty) {
//       return (annotations[0] as Map<String, dynamic>)['description']
//               as String? ??
//           '';
//     }

//     return '';
//   }

//   // ─── Helpers ───────────────────────────────────────────────────────────────
//   void _setStatus(String msg) {
//     if (mounted) setState(() => _statusMessage = msg);
//   }

//   Future<void> _copyText() async {
//     if (_extractedText.isEmpty) return;
//     await Clipboard.setData(ClipboardData(text: _extractedText));
//     setState(() => _copied = true);
//     await Future.delayed(const Duration(seconds: 2));
//     if (mounted) setState(() => _copied = false);
//   }

//   void _clear() => setState(() {
//     _extractedText = '';
//     _pickedImage = null;
//     _statusMessage = '';
//     _copied = false;
//   });

//   // ─── Build ─────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: cs.surface,
//       appBar: AppBar(
//         backgroundColor: cs.surface,
//         elevation: 0,
//         title: Row(
//           children: [
//             Icon(Icons.document_scanner_rounded, color: cs.primary, size: 22),
//             const SizedBox(width: 8),
//             const Text(
//               'Khmer OCR Scanner',
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//             ),
//           ],
//         ),
//         actions: [
//           if (_extractedText.isNotEmpty || _pickedImage != null)
//             IconButton(
//               icon: const Icon(Icons.refresh_rounded),
//               tooltip: 'Clear',
//               onPressed: _clear,
//             ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildImagePreview(cs),
//             _buildActionButtons(cs),
//             if (_statusMessage.isNotEmpty) _buildStatusBar(cs),
//             Expanded(child: _buildTextResult(cs, theme)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePreview(ColorScheme cs) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: _pickedImage != null ? 220 : 160,
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _isProcessing ? cs.primary : cs.outlineVariant,
//           width: _isProcessing ? 2.0 : 1.0,
//         ),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: _pickedImage != null
//           ? Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.file(_pickedImage!, fit: BoxFit.cover),
//                 if (_isProcessing)
//                   Container(
//                     color: Colors.black54,
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CircularProgressIndicator(
//                             color: cs.primary,
//                             strokeWidth: 3,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             _statusMessage,
//                             style: TextStyle(
//                               color: cs.onPrimary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.image_search_rounded,
//                   size: 48,
//                   color: cs.onSurfaceVariant.withOpacity(0.5),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Pick or capture an image to begin',
//                   style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildActionButtons(ColorScheme cs) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: FilledButton.icon(
//               onPressed: _isProcessing
//                   ? null
//                   : () => _pickAndOcr(ImageSource.camera),
//               icon: const Icon(Icons.camera_alt_rounded, size: 18),
//               label: const Text('Camera'),
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: FilledButton.tonalIcon(
//               onPressed: _isProcessing
//                   ? null
//                   : () => _pickAndOcr(ImageSource.gallery),
//               icon: const Icon(Icons.photo_library_rounded, size: 18),
//               label: const Text('Gallery'),
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusBar(ColorScheme cs) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: _isProcessing
//             ? cs.primaryContainer
//             : cs.secondaryContainer.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           if (_isProcessing)
//             SizedBox(
//               width: 14,
//               height: 14,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: cs.onPrimaryContainer,
//               ),
//             )
//           else
//             Icon(
//               Icons.info_outline_rounded,
//               size: 14,
//               color: cs.onSecondaryContainer,
//             ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               _statusMessage,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _isProcessing
//                     ? cs.onPrimaryContainer
//                     : cs.onSecondaryContainer,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextResult(ColorScheme cs, ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: cs.outlineVariant),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.text_snippet_outlined,
//                   size: 16,
//                   color: cs.onSurfaceVariant,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   'Extracted Text',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: cs.onSurfaceVariant,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (_extractedText.isNotEmpty)
//                   GestureDetector(
//                     onTap: _copyText,
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 200),
//                       child: _copied
//                           ? Row(
//                               key: const ValueKey('copied'),
//                               children: [
//                                 Icon(
//                                   Icons.check_rounded,
//                                   size: 14,
//                                   color: cs.primary,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Copied!',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: cs.primary,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Row(
//                               key: const ValueKey('copy'),
//                               children: [
//                                 Icon(
//                                   Icons.copy_rounded,
//                                   size: 14,
//                                   color: cs.onSurfaceVariant,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Copy',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: cs.onSurfaceVariant,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           Expanded(
//             child: _extractedText.isEmpty
//                 ? Center(
//                     child: Text(
//                       _isProcessing
//                           ? 'Reading text…'
//                           : 'Extracted text will appear here',
//                       style: TextStyle(
//                         color: cs.onSurface.withOpacity(0.35),
//                         fontSize: 13,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   )
//                 : Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(14),
//                       child: SelectableText(
//                         _extractedText,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           height: 1.7,
//                           fontSize: 14,
//                           color: cs.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//whit Packagae ==================================================
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class KhmerOcrPage extends StatefulWidget {
//   const KhmerOcrPage({super.key});

//   @override
//   State<KhmerOcrPage> createState() => _KhmerOcrPageState();
// }

// class _KhmerOcrPageState extends State<KhmerOcrPage> {
//   // ─── State ───────────────────────────────────────────────────────────────
//   String _extractedText = '';
//   File? _pickedImage;
//   bool _isProcessing = false;
//   String _statusMessage = '';
//   bool _copied = false;

//   final _picker = ImagePicker();

//   // ML Kit recognizer — use TextRecognitionScript.latin for broad support
//   // For Khmer script, use TextRecognitionScript.devanagari or latin fallback
//   final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//   // ─── Dispose ─────────────────────────────────────────────────────────────
//   @override
//   void dispose() {
//     _textRecognizer.close();
//     super.dispose();
//   }

//   // ─── Pick & OCR ──────────────────────────────────────────────────────────
//   Future<void> _pickAndOcr(ImageSource source) async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: source,
//         imageQuality: 100,
//         preferredCameraDevice: CameraDevice.rear,
//       );
//       if (picked == null) return;

//       setState(() {
//         _isProcessing = true;
//         _extractedText = '';
//         _statusMessage = 'Reading text from image…';
//         _pickedImage = File(picked.path);
//         _copied = false;
//       });

//       // ML Kit input image
//       final inputImage = InputImage.fromFilePath(picked.path);

//       // Run OCR
//       final RecognizedText recognizedText = await _textRecognizer.processImage(
//         inputImage,
//       );

//       // Build full text from all blocks
//       final buffer = StringBuffer();
//       for (final block in recognizedText.blocks) {
//         for (final line in block.lines) {
//           buffer.writeln(line.text);
//         }
//         buffer.writeln(); // blank line between blocks
//       }

//       final result = buffer.toString().trim();

//       setState(() {
//         _extractedText = result.isEmpty
//             ? '⚠️ No text detected.\nTry a clearer image or better lighting.'
//             : result;
//         _isProcessing = false;
//         _statusMessage = result.isEmpty
//             ? 'No text found'
//             : 'Done — ${recognizedText.blocks.length} blocks, '
//                   '${result.split(RegExp(r'\s+')).length} words';
//       });
//     } catch (e) {
//       setState(() {
//         _isProcessing = false;
//         _statusMessage = 'Error: ${e.toString()}';
//         _extractedText = '❌ OCR failed.\n\n${e.toString()}';
//       });
//     }
//   }

//   // ─── Copy to Clipboard ───────────────────────────────────────────────────
//   Future<void> _copyText() async {
//     if (_extractedText.isEmpty) return;
//     await Clipboard.setData(ClipboardData(text: _extractedText));
//     setState(() => _copied = true);
//     await Future.delayed(const Duration(seconds: 2));
//     if (mounted) setState(() => _copied = false);
//   }

//   // ─── Clear ───────────────────────────────────────────────────────────────
//   void _clear() {
//     setState(() {
//       _extractedText = '';
//       _pickedImage = null;
//       _statusMessage = '';
//       _copied = false;
//     });
//   }

//   // ─── Build ───────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: cs.surface,
//       appBar: AppBar(
//         backgroundColor: cs.surface,
//         elevation: 0,
//         title: Row(
//           children: [
//             Icon(Icons.document_scanner_rounded, color: cs.primary, size: 22),
//             const SizedBox(width: 8),
//             const Text(
//               'OCR Scanner',
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//             ),
//           ],
//         ),
//         actions: [
//           if (_extractedText.isNotEmpty || _pickedImage != null)
//             IconButton(
//               icon: const Icon(Icons.refresh_rounded),
//               tooltip: 'Clear',
//               onPressed: _clear,
//             ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── Image Preview ──
//             _buildImagePreview(cs),

//             // ── Action Buttons ──
//             _buildActionButtons(cs),

//             // ── Status bar ──
//             if (_statusMessage.isNotEmpty) _buildStatusBar(cs),

//             // ── Extracted Text ──
//             Expanded(child: _buildTextResult(cs, theme)),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Image Preview Panel ──
//   Widget _buildImagePreview(ColorScheme cs) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: _pickedImage != null ? 220 : 160,
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _isProcessing ? cs.primary : cs.outlineVariant,
//           width: _isProcessing ? 2.0 : 1.0,
//         ),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: _pickedImage != null
//           ? Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.file(_pickedImage!, fit: BoxFit.cover),
//                 if (_isProcessing)
//                   Container(
//                     color: Colors.black54,
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CircularProgressIndicator(
//                             color: cs.primary,
//                             strokeWidth: 3,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Reading text…',
//                             style: TextStyle(
//                               color: cs.onPrimary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.image_search_rounded,
//                   size: 48,
//                   color: cs.onSurfaceVariant.withOpacity(0.5),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Pick or capture an image to begin',
//                   style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
//                 ),
//               ],
//             ),
//     );
//   }

//   // ── Action Buttons ──
//   Widget _buildActionButtons(ColorScheme cs) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: FilledButton.icon(
//               onPressed: _isProcessing
//                   ? null
//                   : () => _pickAndOcr(ImageSource.camera),
//               icon: const Icon(Icons.camera_alt_rounded, size: 18),
//               label: const Text('Camera'),
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: FilledButton.tonalIcon(
//               onPressed: _isProcessing
//                   ? null
//                   : () => _pickAndOcr(ImageSource.gallery),
//               icon: const Icon(Icons.photo_library_rounded, size: 18),
//               label: const Text('Gallery'),
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Status Bar ──
//   Widget _buildStatusBar(ColorScheme cs) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: _isProcessing
//             ? cs.primaryContainer
//             : cs.secondaryContainer.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           if (_isProcessing)
//             SizedBox(
//               width: 14,
//               height: 14,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: cs.onPrimaryContainer,
//               ),
//             )
//           else
//             Icon(
//               Icons.info_outline_rounded,
//               size: 14,
//               color: cs.onSecondaryContainer,
//             ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               _statusMessage,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _isProcessing
//                     ? cs.onPrimaryContainer
//                     : cs.onSecondaryContainer,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Text Result Card ──
//   Widget _buildTextResult(ColorScheme cs, ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: cs.outlineVariant),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Header row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.text_snippet_outlined,
//                   size: 16,
//                   color: cs.onSurfaceVariant,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   'Extracted Text',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: cs.onSurfaceVariant,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (_extractedText.isNotEmpty)
//                   GestureDetector(
//                     onTap: _copyText,
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 200),
//                       child: _copied
//                           ? Row(
//                               key: const ValueKey('copied'),
//                               children: [
//                                 Icon(
//                                   Icons.check_rounded,
//                                   size: 14,
//                                   color: cs.primary,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Copied!',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: cs.primary,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Row(
//                               key: const ValueKey('copy'),
//                               children: [
//                                 Icon(
//                                   Icons.copy_rounded,
//                                   size: 14,
//                                   color: cs.onSurfaceVariant,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Copy',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: cs.onSurfaceVariant,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           // Text body
//           Expanded(
//             child: _extractedText.isEmpty
//                 ? Center(
//                     child: Text(
//                       _isProcessing
//                           ? 'Reading text…'
//                           : 'Extracted text will appear here',
//                       style: TextStyle(
//                         color: cs.onSurface.withOpacity(0.35),
//                         fontSize: 13,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   )
//                 : Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(14),
//                       child: SelectableText(
//                         _extractedText,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           height: 1.7,
//                           fontSize: 14,
//                           color: cs.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
