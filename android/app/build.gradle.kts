// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Plugin Flutter Gradle
    id("dev.flutter.flutter-gradle-plugin")
    
    // Terapkan plugin Google Services
    id("com.google.gms.google-services")
    
    // Terapkan plugin Firebase Crashlytics
    id("com.google.firebase.crashlytics")
}

android {
    // Sesuaikan dengan namespace aplikasi Anda
    namespace = "com.example.nama_aplikasi_anda" 
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // Sesuaikan dengan applicationId aplikasi Anda
        applicationId = "com.example.nama_aplikasi_anda"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            
            // Opsional: Konfigurasi tambahan untuk mapping file Crashlytics jika diperlukan
            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }
        }
    }
}

dependencies {
    // Menggunakan Firebase BoM (Bill of Materials) untuk menyelaraskan versi library Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))

    // Dependensi untuk Firebase Analytics dan Crashlytics
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
}