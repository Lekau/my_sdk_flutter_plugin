plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "za.co.synthesis.halo.test.plugin.my_sdk_flutter_plugin"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "za.co.synthesis.halo.test.plugin.my_sdk_flutter_plugin"
        minSdk = 29 // Required by halo_sdk_flutter_plugin
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        resources {
            // Duplicate metadata from Halo SDK transitive deps (e.g. BouncyCastle).
            excludes += "META-INF/versions/9/OSGI-INF/MANIFEST.MF"
        }
    }
}

flutter {
    source = "../.."
}
