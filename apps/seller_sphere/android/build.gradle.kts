// Hapus blok buildscript yang berisi groovy-all jika tidak sangat diperlukan
// Karena plugin sudah didefinisikan di settings.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Logika pemindahan direktori build (agar tidak mengotori folder project)
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