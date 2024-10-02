import 'package:flutter/foundation.dart' show immutable;

typedef CloseTextListScreen = bool Function();
typedef UpdateTextListScreen = bool Function();

@immutable
class TextListScreenController {
  final CloseTextListScreen close;
  final UpdateTextListScreen update;

  const TextListScreenController({
    required this.close,
    required this.update,
  });
}
