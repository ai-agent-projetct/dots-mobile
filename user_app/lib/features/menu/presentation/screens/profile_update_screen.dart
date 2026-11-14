import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:upgrader/upgrader.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/helpers/textfield_validator.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/show_snackbar.dart';

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
      canPop: true,
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
                              inputFormatters:
                                  widget.keyName == ApiConstants.mobile
                                      ? [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ]
                                      : widget.keyName == ApiConstants.fullName
                                      ? [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'^[\s]+'),
                                        ), // No leading spaces
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z ]'),
                                        ), // Only letters and space
                                        LengthLimitingTextInputFormatter(34),
                                      ]
                                      : widget.keyName == ApiConstants.email
                                      ? [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\s'),
                                        ),
                                      ]
                                      : null,
                              onChanged: (val) {
                                // If it's full name, convert to Camel Case
                                if (widget.keyName == ApiConstants.fullName &&
                                    val.isNotEmpty) {
                                  final words = val.split(" ");
                                  final camelCase = words
                                      .map((word) {
                                        if (word.isEmpty) return '';
                                        return word[0].toUpperCase() +
                                            word.substring(1).toLowerCase();
                                      })
                                      .join(" ");

                                  // Update controller text & cursor position
                                  mProfileProvider
                                      .profileUpdateTextController
                                      .value = TextEditingValue(
                                    text: camelCase,
                                    selection: TextSelection.collapsed(
                                      offset: camelCase.length,
                                    ),
                                  );
                                } else {
                                  mProfileProvider
                                      .profileUpdateTextController
                                      .text = val;
                                }

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
                                return TextFieldValidator.profileUpdateValidation(
                                  widget.keyName,
                                  text.toString().trim(),
                                );
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
