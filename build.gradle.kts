plugins {
    id("com.android.application")
    // Gunakan format yang konsisten dengan settings.gradle.kts
    id("org.jetbrains.kotlin.android") 
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.matrix.sphere"
    // Jika flutter.compileSdkVersion bermasalah, ganti manual ke 34
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.matrix.sphere"
        minSdk = 21 // Minimal SDK untuk Firebase
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Untuk sementara pakai debug key tidak apa-apa, 
            // tapi nanti untuk Microsoft Store/Play Store harus pakai Keystore asli
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // PERBAIKAN: Mengganti <latest_bom_version> dengan versi asli (33.1.1)
    implementation(platform("com.google.firebase:firebase-bom:33.1.1"))
    implementation("com.google.firebase:firebase-crashlytics-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx")
    
    // NDK versi terbaru yang stabil
    implementation("com.google.firebase:firebase-crashlytics-ndk")
}