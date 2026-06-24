plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// PERBAIKAN: Menambahkan JVM Toolchain untuk menyatukan versi Java untuk Kotlin dan Java.
// Ini adalah cara modern untuk mengatasi error "Inconsistent JVM Target Compatibility".
kotlin {
    jvmToolchain(17)
}

android {
    namespace = "com.matrixsphere.connectivity"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Blok compileOptions tidak lagi diperlukan karena sudah diatur oleh toolchain di atas.

    defaultConfig {
        applicationId = "com.matrixsphere.connectivity"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
