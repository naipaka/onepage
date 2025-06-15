import java.util.Properties
import java.io.FileInputStream
import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

// KeyStore for release builds
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

// Extract dart-defines properties.
val dartDefines = mutableMapOf<String, String>()
if (project.hasProperty("dart-defines")) {
    val defines = project.property("dart-defines") as String
    defines.split(",").forEach { entry ->
        val pair = String(Base64.getDecoder().decode(entry), Charsets.UTF_8).split("=")
        if (pair.size == 2) {
            dartDefines[pair[0]] = pair[1]
        }
    }
}

tasks.register<Copy>("selectGoogleServicesJson") {
    from("src/${dartDefines["flavor"]}/google-services.json")
    into("./")
}

tasks.register<Copy>("copySources") {
    from("src/${dartDefines["flavor"]}/res")
    into("src/main/res")
    dependsOn("selectGoogleServicesJson")
}

tasks.whenTaskAdded {
    if (name == "processDebugGoogleServices" || name == "processReleaseGoogleServices") {
        dependsOn("selectGoogleServicesJson")
    }
    dependsOn("copySources")
}

android {
    namespace = "com.naipaka.onepage"
    // flutter_sdk/packages/flutter_tools/gradle/src/main/groovy/flutter.groovy
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets {
        named("main") {
            java.srcDirs("src/main/kotlin")
            res.srcDirs("src/main/res")
        }
    }

    defaultConfig {
        applicationId = dartDefines["appId"]
        // For Firebase.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // For Firebase.
        resValue("string", "app_name", dartDefines["appName"] ?: "")
        // For sqlite3.
        // https://github.com/simolus3/sqlite3.dart/tree/main/sqlite3_flutter_libs#included-platforms
        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }

    signingConfigs {
        named("debug") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM.
    // When using BoM, it is not necessary to specify the version in each Firebase library dependency.
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))

    // See https://firebase.google.com/docs/android/setup#available-libraries
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-crashlytics")
}
