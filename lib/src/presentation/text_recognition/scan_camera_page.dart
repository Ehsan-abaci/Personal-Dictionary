import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/resources/routes_manager.dart';

class ScanCameraPage extends StatefulWidget {
  const ScanCameraPage({super.key});

  @override
  State<ScanCameraPage> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;
  final ValueNotifier isFlashOn = ValueNotifier(false);
  final ValueNotifier isCapturing = ValueNotifier(false);
  final ValueNotifier<double> _zoomLevel = ValueNotifier<double>(1.0);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(state.name.toString());
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  toggleFlashLight() {
    if (_cameraController?.value.flashMode == FlashMode.off) {
      _cameraController?.setFlashMode(FlashMode.torch);
      isFlashOn.value = true;
    } else {
      _cameraController?.setFlashMode(FlashMode.off);
      isFlashOn.value = false;
    }
  }

  File? picturedImage;

  int _pointers = 0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  double _baseScale = 1.0;
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _zoomLevel.value;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_cameraController == null || _pointers != 2) {
      return;
    }
    _zoomLevel.value = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

     _cameraController!.setZoomLevel(_zoomLevel.value);
  }

  _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final file = File(image.path);
    await precacheImage(FileImage(file), context);
    _goToTextRecognitionPage(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _initCameraController(snapshot.data!);
                      return Positioned.fill(
                        bottom: 0,
                        child: Listener(
                          onPointerDown: (_) => _pointers++,
                          onPointerUp: (_) => _pointers--,
                          child: CameraPreview(
                            _cameraController!,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onScaleStart: _handleScaleStart,
                              onScaleUpdate: _handleScaleUpdate,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
              Positioned(
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
                        title: const Text(
                          "Camera scan",
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
              ),
              _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: _pickImageFromGallery,
                                icon: const Icon(
                                  CupertinoIcons.photo_fill_on_rectangle_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: isCapturing,
                                builder: (context, isCapturing, child) =>
                                    ElevatedButton(
                                  onPressed: _takeImage,
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 5,
                                              color: ColorManager.primary)),
                                      fixedSize: const Size.fromRadius(40)),
                                  child: isCapturing
                                      ? const CircularProgressIndicator()
                                      : null,
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: isFlashOn,
                                builder: (context, isOn, child) => IconButton(
                                  onPressed: toggleFlashLight,
                                  icon: Icon(
                                    isOn
                                        ? Icons.flash_on_rounded
                                        : Icons.flash_off_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'Camera permission denied',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);
    _minAvailableZoom = await _cameraController!.getMinZoomLevel();
    _maxAvailableZoom = await _cameraController!.getMaxZoomLevel();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _takeImage() async {
    isCapturing.value = true;
    if (_cameraController == null) return;
    try {
      final pictureFile = await _cameraController!.takePicture();
      isCapturing.value = false;
      final file = File(pictureFile.path);
      if (isFlashOn.value) toggleFlashLight();
      await precacheImage(FileImage(file), context);
      _goToTextRecognitionPage(file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  void _goToTextRecognitionPage(File file) {
    Navigator.pushNamed(
      context,
      Routes.textRecognitionRoute,
      arguments: file,
    );
  }
}
