import 'package:universal_io/io.dart';
import 'package:user/features/menu/data/models/file_upload_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class FileUploadUsecase {
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file);
}
