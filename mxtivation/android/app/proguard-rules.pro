## Keep rules for plugins used in release (safety)

# Path provider (Pigeon-generated interfaces)
-keep class dev.flutter.pigeon.path_provider_android.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# Whisper might rely on JNA on some platforms
-keep class com.sun.jna.* { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }

# Keep Flutter's generated registrant (if referenced directly)
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }