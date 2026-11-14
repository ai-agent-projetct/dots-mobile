import 'package:universal_io/io.dart';
import 'package:user/features/menu/data/models/file_upload_model.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/file_upload_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class FileUploadUsecaseImpl implements FileUploadUsecase {
  final ProfileRepository repository;

  FileUploadUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file) async {
    return repository.fileUpload(file);
  }
}
