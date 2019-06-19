resource "aws_dynamodb_table" "cards" {
  name           = "cards"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-cards"
    Environment = "test"
  }
}
