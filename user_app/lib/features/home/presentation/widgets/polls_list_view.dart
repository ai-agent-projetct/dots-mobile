import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/presentation/provider/poll_provider.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_images.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/loading_widget.dart';

class PollsListView extends ConsumerWidget {
  const PollsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mPollProvider = ref.watch(pollProvider);

    // Loading state
    if (mPollProvider.isLoading && mPollProvider.pollsListData.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    // Error state
    if (mPollProvider.error != null) {
      return Center(
        child: Text(
          'Something went wrong.',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.red,
          ),
        ),
      );
    }

    // Search filter logic
    final searchText = mPollProvider.searchController.text.trim().toLowerCase();

    final filteredList =
        searchText.isEmpty
            ? mPollProvider.pollsListData
            : mPollProvider.pollsListData.where((poll) {
              return (poll.topic ?? "").toLowerCase().contains(searchText) ||
                  poll.question.toLowerCase().contains(searchText);
            }).toList();

    // If nothing matches either poll list or search term
    if (filteredList.isEmpty) {
      return Center(
        child: AppText(
          'No polls available',
          textSize: 14.sp,
          textColor: AppColors.grey,
        ),
      );
    }

    // Poll list view
    return RefreshIndicator(
      onRefresh: mPollProvider.swipeRefresh,
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final poll = filteredList[index];

          final totalVotes = poll.pollOptions!.fold(
            0,
            (sum, option) => sum + int.parse(option.voteTotalCount.toString()),
          );

          final userSelectedOptions =
              poll.pollOptions!
                  .where(
                    (opt) => opt.selectUser!.any(
                      (u) => u.userId == Prefs().getString(Prefs.userId),
                    ),
                  )
                  .map((e) => e.id)
                  .toList();

          final isVoting =
              mPollProvider.loadingPolls[poll.id.toString()] ?? false;

          return Card(
            color: AppColors.splashBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
            elevation: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildPollCard(
                  context,
                  poll,
                  totalVotes,
                  userSelectedOptions,
                  mPollProvider,
                ),
                if (isVoting) const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the Poll card UI
  Widget _buildPollCard(
    BuildContext context,
    PollsListData poll,
    int totalVotes,
    List userSelectedOptions,
    PollProvider mPollProvider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPollHeader(poll),
          SizedBox(height: 10.h),

          // Poll image
          if (poll.image != null && poll.image!.isNotEmpty)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: AppNetworkImage(
                    url: poll.image.toString(),
                    height: 100.h,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),

          // Poll question
          AppText(
            poll.question,
            textSize: 14.sp,
            softWrap: true,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 8.h),

          // Poll options
          ...poll.pollOptions!.map((option) {
            final isSelected = userSelectedOptions.contains(option.id);
            final percentage =
                totalVotes > 0
                    ? (option.voteTotalCount / totalVotes) * 100
                    : 0.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                poll.allowMultipleAnswer == 1
                    ? _buildCheckboxOption(
                      poll.id.toString(),
                      option,
                      isSelected,
                      percentage,
                      mPollProvider,
                    )
                    : _buildRadioOption(
                      poll.id.toString(),
                      option,
                      isSelected,
                      percentage,
                      mPollProvider,
                    ),
                SizedBox(height: 10.h),
              ],
            );
          }),

          horizontalSeparatorWidget(),
          SizedBox(height: 5.h),

          // No vote message
          if (userSelectedOptions.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppText(
                "You haven't voted for this poll.",
                textSize: 12.sp,
                textColor: AppColors.grey,
              ),
            ),
          SizedBox(height: 5.h),

          // View Votes button
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => _showResultsDialog(context, poll),
              child: AppText(
                "View Votes",
                textSize: 12.sp,
                textColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Header
  Widget _buildPollHeader(PollsListData poll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.white,
              child: AppNetworkImage(
                url: poll.pollCreatedUser!.userImage.toString(),
                boxShape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            AppText(
              poll.pollCreatedUser!.userName ?? 'Admin',
              textSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        AppText(
          'Topic: ${poll.topic}',
          textSize: 13.sp,
          lineHeight: 1.h,
          fontWeight: FontWeight.w500,
          textDecoration: TextDecoration.underline,
        ),
      ],
    );
  }

  /// Checkbox option
  Widget _buildCheckboxOption(
    String pollId,
    PollOptions option,
    bool isSelected,
    double percentage,
    PollProvider mPollProvider,
  ) {
    return CheckboxListTile(
      value: isSelected,
      onChanged: (value) {
        mPollProvider.vote(pollId, option.id, true);
      },
      title: _buildOptionTitle(option, percentage),
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: VisualDensity(horizontal: -3.w, vertical: -2.h),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      contentPadding: EdgeInsets.zero,
    );
  }

  /// Radio option
  Widget _buildRadioOption(
    String pollId,
    PollOptions option,
    bool isSelected,
    double percentage,
    PollProvider mPollProvider,
  ) {
    return RadioListTile<String>(
      value: option.id.toString(),
      groupValue: isSelected ? option.id.toString() : null,
      onChanged: (value) {
        if (value != null) {
          mPollProvider.vote(pollId, int.parse(value), false);
        }
      },
      title: _buildOptionTitle(option, percentage),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(horizontal: -3.w, vertical: -2.h),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Option UI
  Widget _buildOptionTitle(PollOptions option, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Option text and vote count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: AppText(
                  option.optionText,
                  textSize: 12.sp,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: AppText("${option.voteTotalCount}", textSize: 12.sp),
            ),
          ],
        ),
        SizedBox(height: 5.h),

        // Progress bar
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          color: AppColors.primary,
        ),
      ],
    );
  }

  /// Results Dialog
  void _showResultsDialog(BuildContext context, PollsListData poll) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Poll Results'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  poll.pollOptions!.map((option) {
                    return ListTile(
                      title: Text(
                        '${option.optionText} - ${option.voteTotalCount} votes',
                      ),
                      subtitle: Text(
                        'Selected by: ${option.selectUser!.map((e) => e.userName).join(', ')}',
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
