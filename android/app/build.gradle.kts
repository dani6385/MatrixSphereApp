plugins {
  alias(libs.plugins.android.application)
  alias(libs.plugins.kotlin.compose)
  alias(libs.plugins.google.devtools.ksp)
  alias(libs.plugins.roborazzi)
  alias(libs.plugins.secrets)
  alias(libs.plugins.google.services)
  alias(libs.plugins.firebase.crashlytics)
}

android {
    namespace = "com.matrix.sphere"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.matrix.sphere"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // PENTING: Anda menggunakan kunci debug untuk build rilis.
            // Anda harus mengkonfigurasi kunci rilis yang benar untuk publikasi ke Play Store.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Menambahkan blok dependensi yang hilang.
// Saya berasumsi 'libs' tersedia dari katalog versi Gradle Anda.
dependencies {
    implementation(platform(libs.firebase.bom))
    implementation(libs.firebase.analytics)
    implementation(libs.firebase.crashlytics)
}

flutter {
    source = "../.."
}
