pluginManagement {
    val flutterSdkPath = run {
        val localPropertiesFile = File(settings.rootDir, "../local.properties")
        if (localPropertiesFile.isFile) {
            val properties = java.util.Properties()
            localPropertiesFile.inputStream().use { properties.load(it) }
            val sdkPath = properties.getProperty("flutter.sdk")
            require(sdkPath != null) { "flutter.sdk not set in local.properties" }
            sdkPath
        } else {
            System.getenv("FLUTTER_SDK") ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file or with a FLUTTER_SDK environment variable.")
        }
    }

    includeBuild(File(flutterSdkPath, "packages/flutter_tools/gradle"))

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    plugins {
        id("com.android.application") version "8.4.1" apply false
        id("org.jetbrains.kotlin.android") version "1.9.23" apply false
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader")
}

rootProject.name = "android"
include(":app")
