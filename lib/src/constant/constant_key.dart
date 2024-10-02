import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['API_KEY'] ?? '';
String rateInAppMyketUrl = dotenv.env['MYKET_RATE_IN_APP'] ?? '' ;

const String EN_FA_BOX = "EN_FA_BOX";
const String DE_FA_BOX = "DE_FA_BOX";
const String DE_EN_BOX = "DE_EN_BOX";
