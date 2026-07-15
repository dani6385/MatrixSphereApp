pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            val localPropertiesFile = file("local.properties")
            
            // Cek jika file local.properties ada (biasanya di laptop lokal)
            if (localPropertiesFile.exists()) {
                localPropertiesFile.inputStream().use { properties.load(it) }
            }
            
            // Ambil dari local.properties, jika tidak ada (seperti di GitHub), ambil dari Environment Variable
            val sdkPath = properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
            
            require(sdkPath != null) { "Flutter SDK not found. Define 'flutter.sdk' in local.properties or set 'FLUTTER_ROOT' environment variable." }
            sdkPath
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
    id("com.android.application") version "8.2.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version "4.4.1" apply false
    id("com.google.firebase.crashlytics") version "2.9.9" apply false
    // END: FlutterFire Configuration
}

include(":app")