import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

group = "co.instil"
version = "1.0"

plugins {
    application
    kotlin("jvm") version "1.3.41"
}

application {
    mainClassName = "co.instil.cardmanagement.CardManagementAppKt"
}

dependencies {
    implementation("software.amazon.awscdk:core:0.36.2.DEVPREVIEW")
    implementation("software.amazon.awscdk:iam:0.36.2.DEVPREVIEW")
    implementation("software.amazon.awscdk:s3:0.36.2.DEVPREVIEW")
    implementation("software.amazon.awscdk:dynamodb:0.36.2.DEVPREVIEW")

    testImplementation("junit:junit:4.12")
    implementation(kotlin("stdlib-jdk8"))
}

repositories {
    mavenCentral()
}

val compileKotlin: KotlinCompile by tasks
compileKotlin.kotlinOptions {
    jvmTarget = "1.8"
}

val compileTestKotlin: KotlinCompile by tasks
compileTestKotlin.kotlinOptions {
    jvmTarget = "1.8"
}