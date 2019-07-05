package co.instil.cardmanagement

import software.amazon.awscdk.core.Construct
import software.amazon.awscdk.core.Stack
import software.amazon.awscdk.services.dynamodb.Attribute
import software.amazon.awscdk.services.dynamodb.AttributeType
import software.amazon.awscdk.services.dynamodb.Table
import software.amazon.awscdk.services.dynamodb.TableProps

class CardManagementStack(parent: Construct, id: String) : Stack(parent, id) {

    init {
        createCardsTable()
    }

    private fun createCardsTable() {

        val partitionKey = Attribute.builder()
                .withName("id")
                .withType(AttributeType.STRING)
                .build()

        val props = TableProps.builder()
                .withTableName("cards-cdk")
                .withReadCapacity(5)
                .withWriteCapacity(5)
                .withPartitionKey(partitionKey)
                .build()

        Table(this, "card-table-cdk", props)
    }

}