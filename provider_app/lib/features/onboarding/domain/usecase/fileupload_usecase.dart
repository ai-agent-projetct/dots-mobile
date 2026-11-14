import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:universal_io/io.dart';

abstract class FileUploadUsecase {
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file);
}
