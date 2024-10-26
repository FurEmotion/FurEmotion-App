import 'package:flutter_dotenv/flutter_dotenv.dart';

class RawApi {
  static String baseroot = dotenv.env['API_BASE_ROOT'] ?? '';

  static String imageURL(
      String? fileId, String middlePath, String defaultPath) {
    if (fileId != null && fileId.contains('http')) {
      return fileId;
    }
    if (fileId == null) {
      return "$baseroot/$middlePath/$defaultPath";
    }
    if (fileId.contains('.')) {
      return "$baseroot/$middlePath/${fileId.split('.').first}";
    }
    return "$baseroot/$middlePath/$fileId";
  }

  static String getPetProfileLink(String? fileId) {
    return RawApi.imageURL(fileId, 'pet/raw/profile', 'default_profile_image');
  }
}
