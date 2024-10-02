import 'dart:developer' as d;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_dictionary/src/constant/functions.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/text_recognition/cubit/recognitioned_texts/recognitioned_texts_cubit.dart';
import 'package:your_dictionary/src/presentation/text_recognition/widgets/drawing_painter.dart';
import 'package:your_dictionary/src/presentation/text_recognition/widgets/text_list/text_list_screen.dart';
import 'package:your_dictionary/src/presentation/text_recognition/widgets/text_submit/text_submit_screen.dart';


class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({
    super.key,
    required this.picturedImage,
  });
  final File picturedImage;
  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  late final ImageProvider _img;
  @override
  void initState() {
    _img = FileImage(widget.picturedImage);
    super.initState();
  }

  final GlobalKey captureContainer = GlobalKey();

  final _linesNotifier = ValueNotifier<List<DrawingLine>>([]);
  final _currentLine = ValueNotifier<DrawingLine?>(null);

  final _penSize = ValueNotifier<double>(20.0);
  final _penColor = ValueNotifier<Color>(ColorManager.yellow.withOpacity(.1));
  final textRecognizer = TextRecognizer();

  int? _activePointerId;

  @override
  void dispose() {
    textRecognizer.close();
    TextSubmitScreen.inst().hide();
    super.dispose();
  }

  Future<ui.Image> _capturePng(
      RenderRepaintBoundary boundary, Offset start, Offset end) async {
    ui.Image image = await boundary.toImage();
    final int width, height;
    if (end.dy - start.dy > end.dx - start.dx) {
      width = end.dx.toInt() - start.dx.toInt() + 28;
    } else {
      width = end.dx.toInt() - start.dx.toInt() + 20;
    }
    height = end.dy.toInt() - start.dy.toInt() + 32;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        start.dx - 13,
        start.dy - 10,
        width.toDouble(),
        height.toDouble(),
      ),
      Rect.fromLTWH(
        0,
        0,
        width.toDouble(),
        height.toDouble(),
      ),
      Paint(),
    );
    ui.Picture picture = recorder.endRecording();

    ui.Image newImage = await picture.toImage(width, height);
    return newImage;
  }

  Future<ui.Image> _capture(Offset s, Offset e) async {
    RenderRepaintBoundary boundary = captureContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image? image = await _capturePng(boundary, s, e);
    return image;
  }

  List<Offset>? _findOffsets() {
    Offset start = Offset.infinite;
    Offset end = Offset.zero;
    if (_currentLine.value == null) return null;
    for (var line in _linesNotifier.value) {
      for (var s in line.offset) {
        if (s.dx < start.dx) start = start.copyWith(dx: s.dx);
        if (s.dx > end.dx) end = end.copyWith(dx: s.dx);
        if (s.dy < start.dy) start = start.copyWith(dy: s.dy);
        if (s.dy > end.dy) end = end.copyWith(dy: s.dy);
      }
    }
    d.log(start.toString());
    d.log(end.toString());
    return [start, end];
  }

  Future<File> convertImageToFile(ui.Image image) async {
    // Get the directory path
    final directory = await getApplicationDocumentsDirectory();

    // Create a new file
    final file = File('${directory.path}/image.png');

    // Convert the image to bytes
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // Write the bytes to the file
    await file.writeAsBytes(bytes!.buffer.asUint8List());

    return file;
  }

  addWord(String text) {
    context.read<RecognitionedTextsCubit>().addWordToList(text);
  }

  clearDrawing() {
    _linesNotifier.value = [];
  }

  submitWords() {
    context.read<RecognitionedTextsCubit>().submitWords();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _scanImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final text = recognizedText.blocks.first.text.split('\n').first;
      if (mounted) {
        TextSubmitScreen.inst()
            .show(context: context, text: text, onCheck: addWord);
      }
    } catch (e) {
      showNotification(
          'An error occurred when scanning text, please specify the bigger area.');
    }
    clearDrawing();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (TextSubmitScreen.inst().isShowing ||
            TextListScreen.inst().isShowing) {
          TextSubmitScreen.inst().hide();
          TextListScreen.inst().hide();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorManager.grey,
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              _getImagePreview(),
              _getBlurAppbar(context),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _getBlurAppbar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 90,
            color: Colors.transparent.withOpacity(.2),
            child: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: ColorManager.white,
              actions: [
                IconButton(
                  onPressed: () => TextListScreen.inst().show(
                    context: context,
                    onCheck: (_) {},
                  ),
                  icon: Badge.count(
                    backgroundColor: ColorManager.primary,
                    count: context
                        .watch<RecognitionedTextsCubit>()
                        .state
                        .texts
                        .length,
                    child: const Icon(CupertinoIcons.square_list),
                  ),
                ),
                IconButton(
                    onPressed: submitWords, icon: const Icon(Icons.check)),
              ],
              title: const Text(
                "Text recognition",
                style: TextStyle(fontSize: 24),
              ),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 20,
                icon: const Icon(CupertinoIcons.back),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _getImagePreview() {
    return Positioned.fill(
      bottom: 0,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        child: ValueListenableBuilder(
          valueListenable: _linesNotifier,
          builder: (context, lines, child) => ColoredBox(
            color: Colors.black.withOpacity(.85),
            child: CustomPaint(
              foregroundPainter: DrawingPainter(lines),
              child: RepaintBoundary(
                key: captureContainer,
                child: Image(
                  image: _img,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointerId) {
      return;
    }
    _activePointerId = null;
    var offsets = _findOffsets();
    if (offsets != null) {
      _capture(offsets[0], offsets[1]).then(
        (image) => convertImageToFile(image).then(
          (file) => _scanImage(file),
        ),
      );
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointerId) {
      return;
    }
    if (_currentLine.value != null) {
      _currentLine.value = DrawingLine(
        [..._currentLine.value!.offset, event.localPosition],
        _currentLine.value!.color,
        _currentLine.value!.penSize,
      );
      _linesNotifier.value =
          _linesNotifier.value.sublist(0, _linesNotifier.value.length - 1) +
              [_currentLine.value!];
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointerId != null) {
      return;
    }
    _activePointerId = event.pointer;
    _currentLine.value = DrawingLine(
      [event.localPosition],
      _penColor.value,
      _penSize.value,
    );
    _linesNotifier.value = [..._linesNotifier.value, _currentLine.value!];
  }
}
