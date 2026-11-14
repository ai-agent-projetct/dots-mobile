import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/alert/presentation/provider/alert_provider.dart';
import 'package:provider/features/alert/presentation/screens/offerpost_dialogue.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/loading_widget.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';

class AlertScreen extends ConsumerStatefulWidget {
  const AlertScreen({super.key});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends ConsumerState<AlertScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(alertProvider).getAllOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final malertprovider = ref.watch(alertProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: translate(AppStringsKey.alertText),
              leadingIconHeight: 22.5.h,
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () {
                ref.read(homeProvider).onItemTap(0);
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (malertprovider.isLoading &&
                      malertprovider.allOffers.isEmpty) {
                    return const Center(child: LoadingWidget());
                  }

                  if (malertprovider.errorMessage != null) {
                    return Center(
                      child: Text(
                        // mTrendsProvider.error!,
                        'Something went wrong.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    );
                  }

                  if (malertprovider.allOffers.isEmpty) {
                    return Center(
                      child: Text(
                        "No alerts available right now!",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      ...List.generate(
                        malertprovider.allOffers.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: offerSection(
                            context: context,
                            index: index,
                            malertprovider: malertprovider, // Pass provider
                            title: malertprovider.allOffers[index].title,
                            description:
                                malertprovider.allOffers[index].description,
                            imageUrl:
                                malertprovider.allOffers[index].uploadImage,
                            fromDate: malertprovider.allOffers[index].startDate,
                            toDate: malertprovider.allOffers[index].expiryDate,
                            // status: malertprovider.allOffers[index]["status"],
                            statusColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () async {
          // Future.microtask(() {
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => OfferpostDialogue(),
          //   );
          // });

          final result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => OfferpostDialogue(),
          );
          if (result == true) {
            ref.read(alertProvider).getAllOffers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            AppImages.addicon,
            fit: BoxFit.cover,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget offerSection({
    required BuildContext context,
    required int index,
    required AlertProvider malertprovider, // Pass the provider instance
    required String title,
    required String description,
    required String imageUrl,
    required String fromDate,
    required String toDate,
    required Color statusColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppStringsKey.poppins,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) => OfferpostDialogue(
                            offerItem: malertprovider.allOffers[index],
                          ),
                    );
                    if (result == true) {
                      ref.read(alertProvider).getAllOffers();
                    }
                  } else if (value == 'delete') {
                    final bool? confirmDelete = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              top: 16.h,
                              bottom: 16.h,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    "Delete Alert",
                                    textSize: 16.sp,
                                    textColor: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 20.h),
                                  AppText(
                                    "Are you sure you want to delete this Alert?",
                                    textColor: AppColors.fontGreyColor,
                                    textSize: 12.sp,
                                  ),
                                  SizedBox(height: 30.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: AppPrimaryButton(
                                          backgroundColor:
                                              AppColors.tabDividerGrey,
                                          text: translate(AppStringsKey.no),
                                          textSize: 14.sp,
                                          textColor: AppColors.secondary,
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: AppPrimaryButton(
                                          text: translate(AppStringsKey.yes),
                                          textSize: 14.sp,
                                          onTap: () {
                                            Navigator.pop(context, true); //
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      // Call the delete API
                      Map<String, dynamic> deleterequest = {"is_delete": 1};
                      await ref
                          .read(alertProvider)
                          .updateOffer(
                            context,
                            malertprovider.allOffers[index].offerId,
                            deleterequest,
                          ); // pass mediaId
                      ref.read(alertProvider).getAllOffers();
                    }
                  }
                },
                icon: const Icon(Icons.more_horiz, color: Colors.black),
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
              ),
            ],
          ),
          AppText(
            description,
            textStyle: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppStringsKey.poppins,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(height: 150, color: Colors.white),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [Expanded(child: Text("From: $fromDate, To: $toDate"))],
          ),
        ],
      ),
    );
  }
}
