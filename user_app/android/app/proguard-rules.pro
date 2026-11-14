-assumenosideeffects class android.util.Log { *; }

#-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
#// uncomment this if you are using firebase in the project
-keep class com.google.firebase.** { *; } 
-dontwarn io.flutter.embedding.**
-ignorewarnings

# Remove unused Kotlin stdlib
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }

# Keep required Play Services classes
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn android.support.**
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}