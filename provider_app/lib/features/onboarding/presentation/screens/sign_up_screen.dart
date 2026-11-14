import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/onboarding/presentation/provider/auth_provider.dart';
import 'package:provider/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:provider/features/onboarding/presentation/widgets/pinmap.dart';
import 'package:provider/features/onboarding/presentation/widgets/terms_and_conditions_widgets.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_multiselectdropdown.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/app_text_field.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:resize/resize.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  late AuthProvider mSignUpProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider).getCategory();
      mSignUpProvider.pwdFocus.addListener(() {
        if (mSignUpProvider.pwdFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.pwdFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
      mSignUpProvider.confirmFocus.addListener(() {
        if (mSignUpProvider.confirmFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.confirmFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
      mSignUpProvider.emailFocus.addListener(() {
        if (mSignUpProvider.emailFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.emailFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
      // **GST Focus**
      mSignUpProvider.gstFocus.addListener(() {
        if (mSignUpProvider.gstFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.gstFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });

      // **Address Focus**
      mSignUpProvider.addressFocus.addListener(() {
        if (mSignUpProvider.addressFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.addressFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });

      // **ID Proof Focus**
      mSignUpProvider.idProofFocus.addListener(() {
        if (mSignUpProvider.idProofFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.idProofFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
    });
  }

  bool validateSignUpFields(
    AuthProvider mSignUpProvider,
    OnboardingProvider monboardingProvider,
  ) {
    // First Name
    if (mSignUpProvider.firstNameController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter First Name");
      return false;
    }

    // Last Name
    if (mSignUpProvider.lastNameController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter Last Name");
      return false;
    }

    // Mobile Number
    if (mSignUpProvider.mobileNumberController.text.trim().isEmpty ||
        mSignUpProvider.mobileNumberController.text.length < 10) {
      CommonUtils.showToast("Please enter a valid Mobile Number");
      return false;
    }

    // Email
    if (mSignUpProvider.emailController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter Email Address");
      return false;
    }

    // Password
    if (mSignUpProvider.passwordController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter Password");
      return false;
    }

    // Confirm Password
    if (mSignUpProvider.confirmPasswordController.text.trim().isEmpty) {
      CommonUtils.showToast("Please confirm Password");
      return false;
    }

    if (monboardingProvider.selectedCategory == null ||
        monboardingProvider.selectedCategory!.isEmpty) {
      CommonUtils.showToast("Please select Category");
      return false;
    }

    if (monboardingProvider.selectedSubCategories.isEmpty) {
      CommonUtils.showToast("Please select Sub Category");
      return false;
    }

    if (mSignUpProvider.passwordController.text.trim() !=
        mSignUpProvider.confirmPasswordController.text.trim()) {
      CommonUtils.showToast("Passwords do not match");
      return false;
    }

    // Address
    if (mSignUpProvider.addressController.text.trim().isEmpty) {
      CommonUtils.showToast("Please select Address");
      return false;
    }

    if (monboardingProvider.selectedImageText.isEmpty) {
      CommonUtils.showToast("Please select ID Proof");
      return false;
    }
    if (monboardingProvider.selectedImage.isEmpty) {
      CommonUtils.showToast("Please upload ID Proof");
      return false;
    }
    // GST Number (optional)
    final gst = mSignUpProvider.gstNumberController.text.trim();
    if (gst.isNotEmpty &&
        !RegExp(
          r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
        ).hasMatch(gst)) {
      CommonUtils.showToast("Enter a valid GST Number");
      return false;
    }

    // Terms & Conditions
    if (mSignUpProvider.isTermsAccepted == false) {
      CommonUtils.showToast("Please accept Terms and Conditions");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    mSignUpProvider = ref.watch(authProvider);
    final monboardingProvider = ref.watch(onboardingProvider);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
              //  top: 10.h,
              bottom: 10.h,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 110.w,
                    height: 60.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.appLogo),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 10.w),
                    child: AppText(
                      translate(AppStringsKey.signUpToAnAccount),
                      textSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                    child: Form(
                      key: mSignUpProvider.signUpFormkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryTextField(
                            mSignUpProvider.firstNameController,
                            hint: "First Name",
                            maxLines: 1,
                            type: TextInputType.text,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'^[\s]+'),
                              ), // No leading spaces
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]'),
                              ), // Only letters and space
                            ],
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                // Convert to Camel Case automatically
                                final words = val.split(" ");
                                final camelCase = words
                                    .map((word) {
                                      if (word.isEmpty) return '';
                                      return word[0].toUpperCase() +
                                          word.substring(1).toLowerCase();
                                    })
                                    .join(" ");

                                // Update controller text with proper cursor position
                                mSignUpProvider
                                    .firstNameController
                                    .value = TextEditingValue(
                                  text: camelCase,
                                  selection: TextSelection.collapsed(
                                    offset: camelCase.length,
                                  ),
                                );
                              }
                            },
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return translate(AppStringsKey.nameValidation);
                              }
                              if (val.length < 3) {
                                return translate(AppStringsKey.nameValidation);
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.lastNameController,
                            hint: "Last Name",
                            maxLines: 1,
                            type: TextInputType.text,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'^[\s]+'),
                              ), // No leading spaces
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]'),
                              ), // Only letters and space
                            ],
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                // Convert to Camel Case automatically
                                final words = val.split(" ");
                                final camelCase = words
                                    .map((word) {
                                      if (word.isEmpty) return '';
                                      return word[0].toUpperCase() +
                                          word.substring(1).toLowerCase();
                                    })
                                    .join(" ");

                                // Update controller text with proper cursor position
                                mSignUpProvider
                                    .lastNameController
                                    .value = TextEditingValue(
                                  text: camelCase,
                                  selection: TextSelection.collapsed(
                                    offset: camelCase.length,
                                  ),
                                );
                              }
                            },
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Last Name must have be 1 to 34 characters";
                              }
                              if (val.length < 1) {
                                return "Last Name must have be 1 to 34 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.mobileNumberController,
                            hint: translate(AppStringsKey.mobileNumber),
                            maxLength: 10,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            type: TextInputType.phone,
                            inputFormatter: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only numbers allowed
                            ],
                            validator: (mob) {
                              if (mob == null || mob.trim().isEmpty) {
                                return translate(
                                  AppStringsKey.mobileValidation,
                                ); // Prevent empty or only-space input
                              }
                              bool isValidPhone = RegExp(
                                r'^\d{10}$',
                              ).hasMatch(mob);
                              if (!isValidPhone) {
                                return translate(
                                  AppStringsKey.mobileValidation,
                                );
                              }
                              return null;
                            },
                            onChanged: (val) {
                              mSignUpProvider.mobileNumberController.text = val;
                              if (val.length < 10) {
                                setState(() {
                                  mSignUpProvider.changeSuffix = false;
                                });
                              }
                            },
                            suffixIcon:
                                mSignUpProvider.changeSuffix == true
                                    ? Padding(
                                      padding: EdgeInsets.only(right: 10.0.w),
                                      child: Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      ),
                                    )
                                    : InkWell(
                                      onTap: () {
                                        debugPrint('verify mobile');

                                        // if (mSignUpProvider.isVerifying) {
                                        //   return;
                                        // }

                                        // if (mSignUpProvider
                                        //         .mobileNumberController
                                        //         .text
                                        //         .length ==
                                        //     10) {
                                        //   mSignUpProvider.startVerifying();
                                        //   CommonUtils.hideKeyBoard(context);

                                        //   Navigator.pushNamed(
                                        //     context,
                                        //     AppRoutes.otp,
                                        //     arguments: {
                                        //       'keyName': 'signup',
                                        //       'mobile':
                                        //           mSignUpProvider
                                        //               .mobileNumberController
                                        //               .text
                                        //               .toString(),
                                        //     },
                                        //   ).then((_) {
                                        //     mSignUpProvider.stopVerifying();
                                        //   });

                                        //   //mSignUpProvider.userCheck('signup');
                                        // } else {
                                        //   showSnackBar(
                                        //     message: translate(
                                        //       AppStringsKey.mobileValidation,
                                        //     ),
                                        //     bgColor: AppColors.primary,
                                        //   );
                                        // }

                                        debugPrint('verify mobile');
                                        if (mSignUpProvider
                                                .mobileNumberController
                                                .text
                                                .length ==
                                            10) {
                                          CommonUtils.hideKeyBoard(context);
                                          mSignUpProvider.userCheck('signup');
                                        } else {
                                          showSnackBar(
                                            message: translate(
                                              AppStringsKey.mobileValidation,
                                            ),
                                            bgColor: Colors.redAccent,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: AppText(
                                          translate(AppStringsKey.verifyText),
                                          textColor: Colors.red,
                                        ),
                                      ),
                                    ),
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 20.h,
                              maxWidth:
                                  mSignUpProvider.changeSuffix == true
                                      ? 30.w
                                      : 50.w,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.emailController,
                            focusNode: mSignUpProvider.emailFocus,
                            hint: translate(AppStringsKey.emailAddress),
                            maxLines: 1,
                            type: TextInputType.emailAddress,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,

                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'\s'),
                              ), // Disallow all spaces
                            ],
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Enter a valid email address"; // Prevent empty or only-space input
                              }

                              final trimmedVal = val.trim();
                              bool isValidEmail = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(trimmedVal);

                              if (!isValidEmail) {
                                return "Enter a valid email address";
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PasswordTextField(
                            mSignUpProvider.passwordController,
                            focusNode: mSignUpProvider.pwdFocus,
                            hint: translate(AppStringsKey.password),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'\s'),
                              ), // Disallow all spaces
                            ],
                            validator: (pwd) {
                              if (pwd == null || pwd.isEmpty) {
                                return translate(
                                  AppStringsKey.pwdValidationText,
                                );
                              }
                              if (pwd.isNotEmpty &&
                                  !RegExp(
                                    r'[!@#$%^&*(),.?":{}|<>]',
                                  ).hasMatch(pwd)) {
                                return translate(
                                  AppStringsKey.pwdValidationSpecial,
                                );
                              }
                              if (pwd.isNotEmpty &&
                                  !RegExp(r'[0-9]').hasMatch(pwd)) {
                                return translate(
                                  AppStringsKey.pwdValidationNumber,
                                );
                              }
                              if (pwd.isNotEmpty && pwd.length < 8) {
                                return translate(
                                  AppStringsKey.pwdValidationText,
                                );
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PasswordTextField(
                            mSignUpProvider.confirmPasswordController,
                            focusNode: mSignUpProvider.confirmFocus,
                            hint: translate(AppStringsKey.confirmPassword),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (pwd) {
                              if (pwd == null || pwd.isEmpty) {
                                return translate(
                                  AppStringsKey.pwdValidationText,
                                );
                              }
                              if (pwd.isNotEmpty &&
                                  mSignUpProvider.passwordController.text !=
                                      pwd) {
                                return translate(AppStringsKey.passwordMatch);
                              }
                              return null;
                            },
                          ),

                          if (monboardingProvider.categoryNames.isNotEmpty)
                            SizedBox(height: 15.h),
                          Visibility(
                            visible:
                                monboardingProvider.categoryNames.isNotEmpty,
                            child: SingleSelectDropdown(
                              title: 'Select Category',
                              hintText: 'Select Category',
                              items: monboardingProvider.categoryNames,
                              onTap: () {
                                CommonUtils.hideKeyBoard(context);
                                if (!mSignUpProvider.changeSuffix) {
                                  showSnackBar(
                                    message: translate(
                                      AppStringsKey.phoneVerifyBefore,
                                    ),
                                  );
                                  return false; // Block dropdown
                                }
                                return true; // Allow dropdown
                              },
                              selectedItem:
                                  monboardingProvider.selectedCategory,
                              onSelectionChanged: (String? selectedItem) async {
                                if (monboardingProvider.selectedCategory ==
                                    selectedItem) {
                                  print(
                                    'Same category selected, skipping API call.',
                                  );
                                  return;
                                }

                                setState(() {
                                  monboardingProvider.selectedCategory =
                                      selectedItem!;
                                });

                                final category = monboardingProvider.categories
                                    .firstWhere(
                                      (cat) => cat.categoryName == selectedItem,
                                    );

                                final categoryId = category.categoryId;
                                print('Selected Category ID: $categoryId');

                                if (categoryId.isNotEmpty) {
                                  await monboardingProvider.getSubCategory(
                                    categoryId,
                                  );
                                  setState(
                                    () {},
                                  ); // rebuild to reflect refreshed subcategories
                                }
                              },
                            ),
                          ),

                          if (monboardingProvider.subCategoryNames.isNotEmpty)
                            SizedBox(height: 15.h),
                          Visibility(
                            visible:
                                monboardingProvider.subCategoryNames.isNotEmpty,
                            child: MultiSelectDropdown(
                              title: 'Sub Category',
                              hintText: 'Sub Category',
                              items: monboardingProvider.subCategoryNames,
                              selectedItems:
                                  monboardingProvider.selectedSubCategories,
                              onTap: () {
                                CommonUtils.hideKeyBoard(context);
                                if (!mSignUpProvider.changeSuffix) {
                                  showSnackBar(
                                    message: translate(
                                      AppStringsKey.phoneVerifyBefore,
                                    ),
                                  );
                                  return false; // Block dropdown
                                }
                                return true; // Allow dropdown
                              },
                              onSelectionChanged: (List<String> selectedItems) {
                                setState(() {
                                  monboardingProvider.selectedSubCategories =
                                      selectedItems;

                                  // 🔹 Print selected names
                                  print(
                                    "Selected Sub Categories: $selectedItems",
                                  );

                                  // 🔹 Find IDs for the selected sub-categories
                                  mSignUpProvider.selectedSubCategoryIds =
                                      monboardingProvider.subCategories
                                          .where(
                                            (subCat) => selectedItems.contains(
                                              subCat.subCategoryName,
                                            ),
                                          )
                                          .map((subCat) => subCat.subCategoryId)
                                          .toList();

                                  // 🔹 Print corresponding IDs
                                  print(
                                    "Selected Sub Category IDs: ${mSignUpProvider.selectedSubCategoryIds}",
                                  );
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.gstNumberController,
                            focusNode: mSignUpProvider.gstFocus,
                            hint: 'GST Number (Optional)',
                            type: TextInputType.text,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                              LengthLimitingTextInputFormatter(15),
                            ],
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                // Simple GST validation pattern (optional field)
                                if (!RegExp(
                                  r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                                ).hasMatch(value)) {
                                  return 'Enter a valid GST Number';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.addressController,
                            focusNode: mSignUpProvider.addressFocus,

                            hint: 'Enter your address',
                            type: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 4,
                            minline: 1,
                            readOnly: true,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Address is required';
                              } else if (value.length <= 10) {
                                return 'Enter a valid address';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () async {
                                CommonUtils.hideKeyBoard(context);

                                if (!mSignUpProvider.changeSuffix) {
                                  showSnackBar(
                                    message: translate(
                                      AppStringsKey.phoneVerifyBefore,
                                    ),
                                  );
                                  return;
                                }
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const LocationPickerScreen(),
                                  ),
                                );

                                if (result != null) {
                                  mSignUpProvider.addressController.text =
                                      result['address'];
                                  // Save LatLng in provider
                                  mSignUpProvider.setLatLng(result['latLng']);

                                  // Print from provider
                                  print(
                                    "Final Data -> Address: ${result['address']}",
                                  );
                                  print(
                                    "Lat: ${mSignUpProvider.selectedLatLng?.latitude}, "
                                    "Lng: ${mSignUpProvider.selectedLatLng?.longitude}",
                                  );
                                }
                              },
                              icon: Icon(Icons.directions),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            TextEditingController(
                              text: monboardingProvider.selectedImageText,
                            ),
                            focusNode: mSignUpProvider.idProofFocus,
                            hint: "ID Proof",
                            readOnly: true,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (monboardingProvider
                                    .selectedImageText
                                    .isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: SizedBox(
                                      height: 30.h,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 5.h,
                                          ),
                                          backgroundColor: AppColors.grey2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5.r,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          CommonUtils.hideKeyBoard(context);
                                          if (!mSignUpProvider.changeSuffix) {
                                            showSnackBar(
                                              message: translate(
                                                AppStringsKey.phoneVerifyBefore,
                                              ),
                                            );
                                            return;
                                          }
                                          monboardingProvider.pickFromGallery();
                                        },
                                        child: AppText(
                                          'Select',
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else if (monboardingProvider
                                    .selectedImage
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: AppText(
                                      'Uploaded',
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: SizedBox(
                                      height: 30.h,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 5.h,
                                          ),
                                          backgroundColor: AppColors.grey2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5.r,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          CommonUtils.hideKeyBoard(context);
                                          if (!mSignUpProvider.changeSuffix) {
                                            showSnackBar(
                                              message: translate(
                                                AppStringsKey.phoneVerifyBefore,
                                              ),
                                            );
                                            return;
                                          }
                                          if (monboardingProvider.pikedImage !=
                                              null) {
                                            // Upload the file
                                            await monboardingProvider
                                                .uploadFile(
                                                  monboardingProvider
                                                      .pikedImage!,
                                                );

                                            // Assign selectedImage after upload
                                            if (monboardingProvider
                                                .selectedImage
                                                .isNotEmpty) {
                                              mSignUpProvider.selectedImage =
                                                  monboardingProvider
                                                      .selectedImage;

                                              // Print selected image path/URL
                                              print(
                                                "Selected Image after upload: ${mSignUpProvider.selectedImage}",
                                              );
                                            } else {
                                              print(
                                                "No image selected or upload failed",
                                              );
                                            }
                                          }
                                        },
                                        child: AppText(
                                          'Upload',
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                // Always show clear icon if something is selected or uploaded
                                if (monboardingProvider
                                        .selectedImageText
                                        .isNotEmpty ||
                                    monboardingProvider
                                        .selectedImage
                                        .isNotEmpty)
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      CommonUtils.hideKeyBoard(context);
                                      if (!mSignUpProvider.changeSuffix) {
                                        showSnackBar(
                                          message: translate(
                                            AppStringsKey.phoneVerifyBefore,
                                          ),
                                        );
                                        return;
                                      }
                                      monboardingProvider.clearImage();
                                    },
                                  ),
                              ],
                            ),

                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 80,
                            ),
                          ),
                          SizedBox(height: 15.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: mSignUpProvider.isTermsAccepted,
                                checkColor: AppColors.primary,
                                activeColor: const Color(0xffffffff),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity(horizontal: -4.0),
                                onChanged: (bool? value) {
                                  CommonUtils.hideKeyBoard(context);
                                  setState(() {
                                    mSignUpProvider.isTermsAccepted =
                                        value ?? false;
                                  });
                                },
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0.w,
                                    color: Color(0xffb9b9b9),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              TermsAndConditionsWidget(),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          AppPrimaryButton(
                            text: translate(AppStringsKey.signup),
                            textSize: 16.sp,
                            showLoader: mSignUpProvider.isLoading,
                            onTap: () async {
                              if (!validateSignUpFields(
                                mSignUpProvider,
                                monboardingProvider,
                              )) {
                                return;
                              }
                              await mSignUpProvider.userSignUp();
                              // If valid, proceed with API call
                              log("All fields are valid. Proceed with sign-up");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(translate(AppStringsKey.alreadyHaveAccount)),
                      SizedBox(width: 5.w),
                      InkWell(
                        onTap: () {
                          mSignUpProvider.clearSignUpValues();
                          Navigator.pop(context);
                        },
                        child: AppText(
                          translate(AppStringsKey.login),
                          textSize: 12.sp,
                          textDecoration: TextDecoration.underline,
                          textColor: AppColors.hyperLinkColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _buildTextField({required String hint, bool obscure = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}

class UploadField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onUpload;

  const UploadField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBorder),
        borderRadius: BorderRadius.circular(5.r),
        color: AppColors.backgroundGrey,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 10.sp),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 30,
            width: 70.w,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: TextButton(
              onPressed: onUpload,
              child: Text(
                "Upload",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
