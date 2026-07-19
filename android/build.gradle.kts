// android/build.gradle.kts

plugins {
    // Hapus nomor versi (seperti version "8.1.0") dari sini
    id("com.android.application") apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("com.google.gms.google-services") apply false
    id("com.google.firebase.crashlytics") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}