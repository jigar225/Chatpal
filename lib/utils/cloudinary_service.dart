

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static final cloudniary = CloudinaryPublic(
    dotenv.env['CLOUDINARY_CLOUD_NAME']!, 
  dotenv.env['CLOUDINARY_UPLOAD_PRESET']!,
  cache: false,
  );

  static Future<CloudinaryResponse> uploadFile(String filePath)async{
    try{
      CloudinaryResponse response = await cloudniary.uploadFile(CloudinaryFile.fromFile(filePath,resourceType: CloudinaryResourceType.Auto));
      return response;
    }catch(e){
      throw Exception('Error uploading file: $e');
    }
  }
}