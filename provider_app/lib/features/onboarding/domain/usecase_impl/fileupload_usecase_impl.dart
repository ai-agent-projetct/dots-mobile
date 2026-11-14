import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/features/onboarding/data/repository_impl/onboarding_repo_impl.dart';
import 'package:provider/features/onboarding/domain/usecase/fileupload_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:universal_io/io.dart';

class FileUploadUsecaseImpl implements FileUploadUsecase {
  final OnboardingRepoImpl repository;

  FileUploadUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file) async {
    return repository.fileUpload(file);
  }
}
