import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

bool kDebugMode = true;
debugLog(msg) {
  kDebugMode ? debugPrint("[LOG] $msg") : "";
}

class ChangeLanguage {
  static String fallbackLocale = 'en';
  static List<String> supportedLocales = ['en', 'hi', 'te', 'ta', 'ka', 'ma'];

  ///This selectedLang value is passed to changeLocale() method when user submits the language.
  static String selectedLanguage =
      languageCodeName.keys.contains(
            Prefs().getString(Prefs.appLanguage).toString(),
          )
          ? Prefs().getString(Prefs.appLanguage).toString()
          : languageCodeName.keys.first;

  ///_tempSelectedLang has selected language before submission which is later cleared when dialog dismissed
  String _tempSelectedLang = "";

  static Map<String, String> languageCodeName = {
    "en": translate(AppStringsKey.english),
    "hi": translate(AppStringsKey.hindi),
    "te": translate(AppStringsKey.telugu),
    "ta": translate(AppStringsKey.tamil),
    "ka": translate(AppStringsKey.kannada),
    "ma": translate(AppStringsKey.malayalam),
  };

  _getLanguageListBuilder(WidgetRef ref) {
    final StateProvider<String> langProvider = StateProvider(
      (ref) => selectedLanguage,
    );
    debugLog("Language before closed: $selectedLanguage");
    for (int i = 0; i < languageCodeName.length; i++) {
      if (languageCodeName.entries.elementAt(i).key ==
          Prefs().getString(Prefs.appLanguage)) {
        selectedLanguage = languageCodeName.entries.elementAt(i).key.toString();
        debugLog(
          "Comparing lang from SharedPref with existing languageCodeName:- Pref: ${Prefs().getString(Prefs.appLanguage)}, languageCodeName: ${languageCodeName.entries.elementAt(i).key}",
        );
        break;
      }
    }
    debugLog("Language after setting from SharedPref: $selectedLanguage");

    return SizedBox(
      height: 400.h,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: languageCodeName.length,
        itemBuilder: (context, index) {
          return Consumer(
            builder: (context, ref, _) {
              final String langCodeAndNameList = ref.watch(langProvider);
              return RadioListTile(
                activeColor: AppColors.primary,
                title: AppText(languageCodeName.entries.elementAt(index).value),
                value: languageCodeName.entries.elementAt(index).key,
                groupValue: langCodeAndNameList,
                onChanged: (value) {
                  debugLog("OnChanged value: $value");
                  ref.read(langProvider.notifier).state = value.toString();
                  _tempSelectedLang = value.toString();
                },
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(thickness: 1.sp, height: 0.5.h);
        },
      ),
    );
  }

  showLanguageDialog(BuildContext context, WidgetRef ref) {
    double borderRadius = 10.r;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.h,
                              bottom: 15.h,
                              left: 15.w,
                            ),
                            child: AppText(
                              translate(AppStringsKey.chooseLanguage),
                              fontWeight: FontWeight.w600,
                              textSize: 16.sp,
                            ),
                          ),
                          _getLanguageListBuilder(ref),
                        ],
                      ),
                    ),
                    AppPrimaryButton(
                      fontWeight: FontWeight.w600,
                      textSize: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                        color: AppColors.primary,
                      ),
                      text: translate(AppStringsKey.changeLanguage),
                      onTap: () {
                        _tempSelectedLang != ""
                            ? selectedLanguage = _tempSelectedLang
                            : "";
                        changeLocale(context, selectedLanguage);
                        Prefs().setString(Prefs.appLanguage, selectedLanguage);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _tempSelectedLang = "");
  }
}
