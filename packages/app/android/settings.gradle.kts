pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // Check the latest version here: Google Services Gradle Plugin
    // https://mvnrepository.com/artifact/com.android.tools.build/gradle
    id("com.android.application") version "8.10.1" apply false
    // Check the latest version here: Kotlin Releases
    // https://kotlinlang.org/docs/releases.html#release-details
    id("org.jetbrains.kotlin.android") version "2.2.21" apply false
    // Check the latest version here: Firebase Android SDK Release Notes
    // https://firebase.google.com/support/release-notes/android
    id("com.google.gms.google-services") version "4.4.4" apply false // For Firebase.
    id("com.google.firebase.crashlytics") version "3.0.6" apply false // For Crashlytics.
}

include(":app")
