// android/build.gradle.kts

plugins {
    // Plugin default bawaan Flutter
    id("com.android.application") version "8.1.0" apply false
    id("com.android.library") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    
    // Tambahkan plugin Google Services
    id("com.google.gms.google-services") version "4.4.1" apply false
    
    // Tambahkan plugin Firebase Crashlytics
    id("com.google.firebase.crashlytics") version "2.9.9" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}