plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
//    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "infosys.broadway.octapreview"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "infosys.broadway.octapreview"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
//    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // Add the dependencies for Firebase products you want to use
//    implementation("com.google.firebase:firebase-analytics-ktx")
//    implementation("com.google.firebase:firebase-auth-ktx")
//    implementation("com.google.firebase:firebase-firestore-ktx")
//    implementation("com.google.firebase:firebase-storage-ktx")

    // Add any other Firebase dependencies as needed
}