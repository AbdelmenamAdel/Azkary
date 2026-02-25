# Keep generic type information for Gson TypeToken
-keepattributes Signature
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep flutter_local_notifications plugin classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Gson TypeToken classes
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class com.google.gson.reflect.TypeToken$* { *; }

# Keep all model classes used for notifications
-keep class com.dexterous.** { *; }