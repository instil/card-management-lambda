package co.instil.cardmanagement

import software.amazon.awscdk.core.App

fun main() {
    val app = App()

    CardManagementStack(app, "card-management-cdk")

    app.synth()
}