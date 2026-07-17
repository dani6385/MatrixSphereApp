// File: android/build.gradle

buildscript {
    ext.kotlin_version = "1.8.22"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}
// ... sisa file


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Konfigurasi Android harus dilakukan SEBELUM evaluationDependsOn
    plugins.withType<com.android.build.gradle.BasePlugin> {
        extensions.configure<com.android.build.gradle.BaseExtension> {
            compileOptions.sourceCompatibility = JavaVersion.VERSION_1_8
            compileOptions.targetCompatibility = JavaVersion.VERSION_1_8
        }
    }

    // Hanya panggil evaluationDependsOn jika ini bukan proyek :app itu sendiri
    if (project.name != "app") {
        evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}