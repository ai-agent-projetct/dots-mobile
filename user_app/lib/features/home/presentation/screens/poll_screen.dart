import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/provider/poll_provider.dart';
import 'package:user/features/home/presentation/widgets/create_poll_dialog.dart';
import 'package:user/features/home/presentation/widgets/polls_list_view.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';

class PollScreen extends ConsumerStatefulWidget {
  const PollScreen({super.key});

  @override
  PollScreenState createState() => PollScreenState();
}

class PollScreenState extends ConsumerState<PollScreen> {
  late PollProvider mPollProvider;
  bool showSuggestions = false;
  List<String> suggestionList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // clear search when screen loads
      mPollProvider.searchController.clear();
      showSuggestions = false;

      // load all polls & topics
      mPollProvider.getListOfPolls(null);
      mPollProvider.getTopicsOfPoll();
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      // When cleared, hide suggestions and show all polls
      setState(() {
        showSuggestions = false;
        suggestionList.clear();
      });
      mPollProvider.notifyListeners();
      return;
    }

    final suggestions =
        mPollProvider.topicsData
            .map((t) => t.topic ?? "")
            .where(
              (topic) =>
                  topic.toLowerCase().contains(query.trim().toLowerCase()),
            )
            .toList();

    setState(() {
      suggestionList = suggestions.toSet().toList().cast<String>();
      showSuggestions = suggestionList.isNotEmpty;
    });

    if (suggestionList.isEmpty) {
      mPollProvider.notifyListeners();
    }
  }

  void _onSuggestionSelected(String selectedTopic) {
    mPollProvider.searchController.text = selectedTopic;

    setState(() {
      showSuggestions = false;
    });
    mPollProvider.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    mPollProvider = ref.watch(pollProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from poll screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: translate(AppStringsKey.talks),
                    leadingIconHeight: 22.5.h,
                    textSize: 16.sp,
                    showLeadingIcon: true,
                    leadingIconEnabled: true,
                    onTap: () {
                      ref.read(homeProvider).onItemTap(0);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryTextField(
                                mPollProvider.searchController,
                                textInputAction: TextInputAction.search,
                                hint: "Search by topic",
                                fillColor: const Color(0xFFEAEAEA),
                                contentPadding: EdgeInsets.only(left: 40.w),
                                onChanged: _onSearchChanged,
                                inputBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFEAEAEA),
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  child: const Icon(Icons.search),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  maxHeight: 20.h,
                                  maxWidth: 50.w,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  CommonUtils.hideKeyBoard(context);
                                  mPollProvider.searchController.clear();

                                  setState(() {
                                    showSuggestions = false;
                                    suggestionList.clear();

                                    if (value == "asc") {
                                      // Sort by topic in ascending order
                                      mPollProvider.pollsListData.sort(
                                        (a, b) => (a.topic ?? "")
                                            .toLowerCase()
                                            .compareTo(
                                              (b.topic ?? "").toLowerCase(),
                                            ),
                                      );
                                    } else if (value == "desc") {
                                      // Sort by topic in descending order
                                      mPollProvider.pollsListData.sort(
                                        (a, b) => (b.topic ?? "")
                                            .toLowerCase()
                                            .compareTo(
                                              (a.topic ?? "").toLowerCase(),
                                            ),
                                      );
                                    }
                                  });

                                  // Refresh the list view
                                  mPollProvider.notifyListeners();
                                },
                                color:
                                    Colors
                                        .white, // Background color of the menu
                                elevation: 4, // Drop shadow
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                itemBuilder:
                                    (context) => [
                                      const PopupMenuItem(
                                        value: "asc",
                                        child: Text("Sort Ascending by Topic"),
                                      ),
                                      const PopupMenuItem(
                                        value: "desc",
                                        child: Text("Sort Descending by Topic"),
                                      ),
                                    ],
                                child: Image.asset(
                                  AppImages.filter,
                                  width: 25.w,
                                  height: 25.h,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Suggestions dropdown
                      ],
                    ),
                  ),

                  // Poll list view
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: const PollsListView(),
                    ),
                  ),
                ],
              ),
              if (showSuggestions)
                Positioned(
                  top: 90.h,
                  left: 10.w,
                  right: 10.w,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 200.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: suggestionList.length,

                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: AppText(suggestionList[index]),
                            onTap: () {
                              CommonUtils.hideKeyBoard(context);
                              _onSuggestionSelected(suggestionList[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'pollFab',
          shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const CreatePollDialog(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              AppImages.pollCreate,
              fit: BoxFit.cover,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
