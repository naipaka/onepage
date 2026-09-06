allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Align each module's Kotlin JVM target with the Java target that module
// already declares.
//
// Plugins that only configure their Kotlin jvmTarget when
// `android.builtInKotlin=true` (photo_manager 3.10.0, for example) leave it
// unset for this app, because the Flutter migrator pinned that flag to false in
// gradle.properties. Kotlin then falls back to the JDK running Gradle, so
// building with a JDK newer than the module's Java target fails with
// "Inconsistent JVM-target compatibility detected for tasks
// 'compileDebugJavaWithJavac' and 'compileDebugKotlin'".
//
// Targets are copied per module rather than forced to a single value, because
// plugins do not agree on one (:app and photo_manager use 17, app_settings
// uses 11).
//
// The Java target is read through a provider: AGP has not finalized
// `compileOptions` while the project is still being evaluated, so the value can
// only be queried once the Kotlin task is realized.
subprojects {
    val module = this
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(
                module.provider {
                    @Suppress("DEPRECATION")
                    val androidExtension =
                        module.extensions.findByName("android")
                            as? com.android.build.gradle.BaseExtension
                    val javaTarget = androidExtension?.compileOptions?.targetCompatibility
                        ?: JavaVersion.VERSION_17
                    org.jetbrains.kotlin.gradle.dsl.JvmTarget.fromTarget(javaTarget.toString())
                },
            )
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
