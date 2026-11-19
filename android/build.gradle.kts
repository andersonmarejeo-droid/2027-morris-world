import com.android.build.api.dsl.LibraryExtension

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

// Older Android plugins declare their namespace only through a legacy
// conditional that AGP 9 no longer evaluates. Supply the package namespaces
// from the application build so release builds remain reproducible without
// editing the global Pub cache.
val legacyPluginNamespaces = mapOf(
    "audioplayers_android" to "xyz.luan.audioplayers",
    "cloud_firestore" to "io.flutter.plugins.firebase.firestore",
    "cloud_functions" to "io.flutter.plugins.firebase.functions",
    "firebase_app_check" to "io.flutter.plugins.firebase.appcheck",
    "firebase_auth" to "io.flutter.plugins.firebase.auth",
    "firebase_core" to "io.flutter.plugins.firebase.core",
    "firebase_database" to "io.flutter.plugins.firebase.database",
    "firebase_remote_config" to "io.flutter.plugins.firebase.firebaseremoteconfig",
    "google_mobile_ads" to "io.flutter.plugins.googlemobileads",
    "jni" to "com.github.dart_lang.jni",
    "jni_flutter" to "com.github.dart_lang.jni_flutter",
    "sqflite_android" to "com.tekartik.sqflite",
)

subprojects {
    val legacyNamespace = legacyPluginNamespaces[name]
    if (legacyNamespace != null) {
        plugins.withId("com.android.library") {
            extensions.configure<LibraryExtension> {
                namespace = legacyNamespace
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
