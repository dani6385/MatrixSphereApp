buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Menggunakan tanda petik ganda dan tanda kurung untuk Kotlin DSL
        classpath("com.android.tools.build:gradle:8.4.0")
        // Menambahkan classpath untuk plugin Kotlin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.24")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}