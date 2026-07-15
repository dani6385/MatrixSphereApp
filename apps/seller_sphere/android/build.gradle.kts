buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Tambahkan dependensi Groovy untuk memperbaiki masalah XmlSlurper dengan AGP 8.x+
        classpath("org.codehaus.groovy:groovy-all:3.0.21")
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
