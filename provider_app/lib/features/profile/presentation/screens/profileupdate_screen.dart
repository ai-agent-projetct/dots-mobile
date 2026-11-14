import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_constants.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/loading_widget.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:resize/resize.dart';

class ProfileUpdateScreen extends ConsumerStatefulWidget {
  final String? keyName;
  final String? data;
  final String? title;
  final String? desc;
  const ProfileUpdateScreen({
    super.key,
    this.keyName,
    this.data,
    this.title,
    this.desc,
  });

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends ConsumerState<ProfileUpdateScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ref.read(profileProvider).profileUpdateTextController.text =
        widget.data.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mProfileProvider = ref.watch(profileProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: widget.title.toString(),
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    mProfileProvider.changeSuffix = true;
                  });
                  mProfileProvider.profileUpdateTextController.clear();
                },
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller:
                                  mProfileProvider.profileUpdateTextController,
                              keyboardType:
                                  widget.keyName == ApiConstants.email
                                      ? TextInputType.emailAddress
                                      : widget.keyName == ApiConstants.mobile
                                      ? TextInputType.phone
                                      : TextInputType.text,
                              onChanged: (val) {
                                mProfileProvider
                                    .profileUpdateTextController
                                    .text = val;
                                debugPrint('widget data --> ${widget.data}');
                                if (mProfileProvider
                                        .profileUpdateTextController
                                        .text !=
                                    widget.data) {
                                  if (val.length < 10) {
                                    setState(() {
                                      mProfileProvider.changeSuffix = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    mProfileProvider.changeSuffix = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2.0.w,
                                  ),
                                ),
                                suffixIcon:
                                    widget.keyName == ApiConstants.mobile
                                        ? mProfileProvider.changeSuffix == true
                                            ? Padding(
                                              padding: EdgeInsets.only(
                                                right: 10.0.w,
                                              ),
                                              child: Icon(
                                                Icons.verified,
                                                color: Colors.green,
                                              ),
                                            )
                                            : InkWell(
                                              onTap: () {
                                                debugPrint('verify mobile');
                                                if (mProfileProvider
                                                        .profileUpdateTextController
                                                        .text
                                                        .length ==
                                                    10) {
                                                  CommonUtils.hideKeyBoard(
                                                    context,
                                                  );
                                                  mProfileProvider.userCheck(
                                                    mProfileProvider
                                                        .profileUpdateTextController
                                                        .text
                                                        .toString(),
                                                    widget.keyName,
                                                  );
                                                } else {
                                                  showSnackBar(
                                                    message: translate(
                                                      AppStringsKey
                                                          .mobileValidation,
                                                    ),
                                                    bgColor: Colors.redAccent,
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 10.0.w,
                                                ),
                                                child: AppText(
                                                  translate(
                                                    AppStringsKey.verifyText,
                                                  ),
                                                  textColor: Colors.red,
                                                ),
                                              ),
                                            )
                                        : null,
                                suffixIconConstraints:
                                    widget.keyName == ApiConstants.mobile
                                        ? BoxConstraints(
                                          maxHeight: 20.h,
                                          maxWidth:
                                              mProfileProvider.changeSuffix ==
                                                      true
                                                  ? 30.w
                                                  : 50.w,
                                        )
                                        : null,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                // return TextFieldValidator
                                //     .profileUpdateValidation(
                                //         widget.keyName, text.toString().trim());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: mProfileProvider.isLoading,
                      child: LoadingWidget(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AppPrimaryButton(
                  text: translate(AppStringsKey.updateText),
                  onTap: () {
                    CommonUtils.hideKeyBoard(context);
                    if (formKey.currentState!.validate()) {
                      if (widget.keyName == ApiConstants.mobile &&
                          mProfileProvider.changeSuffix == false) {
                        showSnackBar(
                          message: translate(AppStringsKey.phoneVerifyProfile),
                          bgColor: Colors.redAccent,
                        );
                      } else {
                        ref
                            .read(profileProvider)
                            .updateProfile(
                              fieldName: widget.keyName,
                              value:
                                  mProfileProvider
                                      .profileUpdateTextController
                                      .text
                                      .toString()
                                      .trim(),
                            );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 5.vh),
            ],
          ),
        ),
      ),
    );
  }
}
