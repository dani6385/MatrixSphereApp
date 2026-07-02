include(":app")

val flutterSdkPath = "/opt/hostedtoolcache/flutter"

apply(from = java.io.File(flutterSdkPath, "packages/flutter_tools/gradle/app_plugin_loader.gradle"))
