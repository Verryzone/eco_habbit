# Keep all Supabase related classes
-keep class io.supabase.** { *; }
-keep class supabase.** { *; }

# Keep Dart classes from being obfuscated
-keep class io.flutter.plugins.** { *; }

# Keep network classes
-keep class java.net.** { *; }
-keep class javax.net.ssl.** { *; }

# Keep HTTP client
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

# Keep JSON serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Network security
-keep class android.security.net.config.** { *; }
