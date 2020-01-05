require 'aws-sdk'

client =  Aws::DynamoDB::Client.new(region: 'ap-northeast-2')

resp = client.create_table({
  table_name: "hwahae-api-prod-products", # required
  attribute_definitions: [ # required
    {
      attribute_name: "stat", # required
      attribute_type: "S", # required, accepts S, N, B
    },
    {
      attribute_name: "id", # required
      attribute_type: "N", # required, accepts S, N, B
    },
    {
      attribute_name: "oily_score", # required
      attribute_type: "N", # required, accepts S, N, B
    },
    {
      attribute_name: "dry_score", # required
      attribute_type: "N", # required, accepts S, N, B
    },
    {
      attribute_name: "sensitive_score", # required
      attribute_type: "N", # required, accepts S, N, B
    },
  ],
  key_schema: [ # required
    {
      attribute_name: "stat", # required
      key_type: "HASH", # required, accepts HASH, RANGE
    },
    {
      attribute_name: "id", # required
      key_type: "RANGE", # required, accepts HASH, RANGE
    },
  ],
  local_secondary_indexes: [
    {
        index_name: "oily_score_index", # required
        key_schema: [ # required
          {
            attribute_name: "stat", # required
            key_type: "HASH", # required, accepts HASH, RANGE
          },
          {
            attribute_name: "oily_score", # required
            key_type: "RANGE", # required, accepts HASH, RANGE
          },
        ],
        projection: { # required
          projection_type: "ALL" # accepts ALL, KEYS_ONLY, INCLUDE
        },
    },
    {
      index_name: "dry_score_index", # required
      key_schema: [ # required
        {
          attribute_name: "stat", # required
          key_type: "HASH", # required, accepts HASH, RANGE
        },
        {
          attribute_name: "dry_score", # required
          key_type: "RANGE", # required, accepts HASH, RANGE
        },
      ],
      projection: { # required
        projection_type: "ALL" # accepts ALL, KEYS_ONLY, INCLUDE
      },
    },
    {
        index_name: "sensitive_score_index", # required
        key_schema: [ # required
          {
            attribute_name: "stat", # required
            key_type: "HASH", # required, accepts HASH, RANGE
          },
          {
            attribute_name: "sensitive_score", # required
            key_type: "RANGE", # required, accepts HASH, RANGE
          },
        ],
        projection: { # required
          projection_type: "ALL" # accepts ALL, KEYS_ONLY, INCLUDE
        },
      },
  ],
  provisioned_throughput: {
    read_capacity_units: 5, # required
    write_capacity_units: 5, # required
  }
})