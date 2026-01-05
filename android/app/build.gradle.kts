plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "top.amirdeveloper.skeleton"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "top.amirdeveloper.skeleton"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
//            keyAlias = keystoreProdProperties["keyAlias"] as String
//            keyPassword = keystoreProdProperties["keyPassword"] as String
//            storeFile = file(keystoreProdProperties["storeFile"] as String)
//            storePassword = keystoreProdProperties["storePassword"] as String
            storeFile = file("${System.getProperty("user.home")}/.android/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        getByName("debug") {
//            keyAlias = keystoreProdProperties["keyAlias"] as String
//            keyPassword = keystoreProdProperties["keyPassword"] as String
//            storeFile = file(keystoreProdProperties["storeFile"] as String)
//            storePassword = keystoreProdProperties["storePassword"] as String

            storeFile = file("${System.getProperty("user.home")}/.android/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }


    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
            ndk {
                debugSymbolLevel = "none"
            }

        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
    flavorDimensions.add("Skeleton")
    productFlavors {
        create("dev") {
            dimension = "Skeleton"
            versionNameSuffix = "-dev"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Dev Skeleton")
            signingConfig = signingConfigs.getByName("debug")
        }

        create("stage") {
            dimension = "Skeleton"
            versionNameSuffix = "-stage"
            applicationIdSuffix = ".stage"
            resValue("string", "app_name", "Stage Skeleton")
            signingConfig = signingConfigs.getByName("debug")
        }

        create("prod") {
            dimension = "Skeleton"
            resValue("string", "app_name", "Skeleton")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
