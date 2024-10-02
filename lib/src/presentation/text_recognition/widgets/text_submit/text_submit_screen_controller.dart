import 'package:flutter/foundation.dart' show immutable;

typedef CloseTextSubmitScreen = bool Function();
typedef UpdateTextSubmitScreen = bool Function(String text);

@immutable
class TextSubmitScreenController {
  final CloseTextSubmitScreen close;
  final UpdateTextSubmitScreen update;

  const TextSubmitScreenController({
    required this.close,
    required this.update,
  });
}
