import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/data/models/poll_model.dart';
import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/features/home/domain/usecase/create_poll_usecase.dart';
import 'package:user/features/home/domain/usecase/poll_topics_usecase.dart';
import 'package:user/features/home/domain/usecase/polls_list_usecase.dart';
import 'package:user/features/home/domain/usecase/vote_poll_usecase.dart';
import 'package:user/features/menu/domain/usecase/file_upload_usecase.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class PollProvider extends ChangeNotifier {
  PollsListUsecase pollsListUsecase;
  PollTopicsUsecase pollTopicsUsecase;
  FileUploadUsecase fileUploadUsecase;
  CreatePollUsecase createPollUsecase;
  VotePollUsecase votePollUsecase;

  final List<Poll> polls = [];

  List<PollsListData> pollsListData = [];
  List<PollTopicsData> topicsData = [];
  String selectedTopics = "";
  String selectedTopicId = "";

  String selectedImageText = "";
  String selectedImage = "";
  File? choosedImage;

  Map<String, List<int>> selectedOptions = {};

  bool isLoading = false;
  Map<String, bool> loadingPolls = {};

  final TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers = [TextEditingController()];

  bool allowMultipleAnswers = false;

  final searchController = TextEditingController();

  PollProvider(
    this.pollsListUsecase,
    this.pollTopicsUsecase,
    this.fileUploadUsecase,
    this.createPollUsecase,
    this.votePollUsecase,
  );
  String? error;
  Future<void> getListOfPolls(String? pollId) async {
    if (pollId == null) {
      setLoader(true);
      error = null;
    }
    var data = await pollsListUsecase.getPollsList();
    if (data.isLeft()) {
      setLoader(false);
      error = data.getLeft().error;
      // showSnackBar(message: data.getLeft().error);
    } else {
      pollsListData = data.getRight().pollsListData!;

      selectedOptions.clear();
      for (var poll in pollsListData) {
        final userSelectedOptions =
            poll.pollOptions!
                .where(
                  (opt) => opt.selectUser!.any(
                    (u) => u.userId == Prefs().getString(Prefs.userId),
                  ),
                )
                .map((e) => e.id as int)
                .toList();
        if (userSelectedOptions.isNotEmpty) {
          selectedOptions[poll.id.toString()] = userSelectedOptions.cast<int>();
        }
      }
      setLoader(false);
      notifyListeners();
    }
  }

  void addOption() {
    if (optionControllers.length < 4) {
      optionControllers.add(TextEditingController());
      notifyListeners();
    }
  }

  Future<void> getTopicsOfPoll() async {
    setLoader(true);
    var data = await pollTopicsUsecase.getPollTopics();
    if (data.isLeft()) {
      setLoader(false);
      //   showSnackBar(message: data.getLeft().error);
    } else {
      topicsData = data.getRight().pollTopicsData!;
      setLoader(false);
      notifyListeners();
    }
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void setSelectedTopic(String topicId, String topicName) {
    selectedTopicId = topicId;
    selectedTopics = topicName;
    debugPrint('selected topic id: $topicId');
    debugPrint('selected topic name: $topicName');
    notifyListeners();
  }

  void uploadFile(File file) async {
    setLoader(true);
    var data = await fileUploadUsecase.fileUpload(file);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
      setLoader(false);
    } else {
      if (data.getRight().data != null) {
        if (data.getRight().data!.imageUrl != null) {
          selectedImage = data.getRight().data!.imageUrl.toString();
          notifyListeners();
        }
      }
      setLoader(false);
    }
  }

  void clearImage() {
    selectedImage = "";
    selectedImageText = "";
    debugPrint('cleared images');
    notifyListeners();
  }

  void selectFromGallery(File file) {
    choosedImage = file;
    selectedImageText = file.path.split('/').last;
    notifyListeners();
  }

  addPoll() async {
    setLoader(true);
    final question = questionController.text;
    final options =
        optionControllers
            .map((controller) => controller.text)
            .where((option) => option.isNotEmpty)
            .toList();

    if (question.isNotEmpty && options.isNotEmpty) {
      await pollCreate(question, options);
      setLoader(false);
      return true;
    } else {
      setLoader(false);
      return false;
    }
  }

  pollCreate(String question, List<String> options) async {
    try {
      var body = {
        "user_id": Prefs().getString(Prefs.userId),
        "question": question,
        "options": options,
        "allow_multiple_answer": allowMultipleAnswers,
        "topic_id": selectedTopicId.toString(),
        "image": selectedImage.toString(),
      };
      var data = await createPollUsecase.createPoll(body);
      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
      } else {
        clearControllers();
      }
    } catch (e) {
      debugPrint('poll provider catch error for poll create: ${e.toString()}');
    }
  }

  Future<void> swipeRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    getListOfPolls(null);
  }

  // Cast a vote
  Future<void> vote(String pollId, int optionId, bool allowMultiple) async {
    loadingPolls[pollId] = true;
    notifyListeners();

    if (allowMultiple) {
      final selected = selectedOptions[pollId] ?? [];
      if (selected.contains(optionId)) {
        selected.remove(optionId);
      } else {
        selected.add(optionId);
      }
      selectedOptions[pollId] = List.from(selected);
    } else {
      selectedOptions[pollId] = [optionId];
    }

    await sendVoteToApi(pollId, selectedOptions[pollId]!);

    loadingPolls[pollId] = false;
    notifyListeners();
  }

  sendVoteToApi(String pollId, List<int> list) async {
    try {
      var body = {
        "user_id": Prefs().getString(Prefs.userId),
        "option_id": list,
        "poll_id": pollId,
      };
      debugPrint('$body');
      var data = await votePollUsecase.votePoll(body);
      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
      } else {
        await getListOfPolls(pollId);
      }
    } catch (e) {
      debugPrint('poll provider catch error for vote poll: ${e.toString()}');
    }
  }

  // Toggle allowMultipleAnswers
  void toggleAllowMultipleAnswers(bool value) {
    allowMultipleAnswers = value;
    notifyListeners();
  }

  // Clear controllers after adding a poll
  void clearControllers() {
    debugPrint('cleared controllers');
    questionController.clear();
    selectedTopicId = "";
    selectedTopics = "";
    for (var controller in optionControllers) {
      controller.clear();
    }
    allowMultipleAnswers = false;
    optionControllers = [TextEditingController()];
    notifyListeners();
    clearImage();
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
