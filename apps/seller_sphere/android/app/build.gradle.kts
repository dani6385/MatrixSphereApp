// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // Catatan: "kotlin-android" sengaja dihapus di sini untuk migrasi Built-in Kotlin
}

android {
    // PENTING: Ganti "com.seller.sphere" dengan ID Paket asli Anda
    // (Bisa dilihat di dalam file google-services.json pada bagian "package_name")
    namespace = "com.seller.sphere" 
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // PENTING: Samakan juga ID aplikasi di bawah ini dengan nama paket asli Anda
        applicationId = "com.seller.sphere"
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

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
}