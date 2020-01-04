require 'aws-sdk'
dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
table = dynamodb.table('hwahae-api-prod-products')

# index dry_score desc
products = table.query({
    index_name: 'dry_score_index',
    key_condition_expression: "stat = :stat",
    expression_attribute_values: {
        ":stat" => "ok"
    },
    projection_expression: "image_id, full_size_image, title, price, oily_score, dry_score, sensitive_score",
    scan_index_forward: false, # false면 내림차순, true면 오름차순
    limit: 20
})

puts products.items
puts products.last_evaluated_key

# index (oily_score asc)
# products = table.scan({
#     projection_expression: "image_id, full_size_image, title, price, oily_score, dry_score, sensitive_score",
#     limit: 20
# })

# puts(JSON.pretty_generate(products.items));

# # show
# products = table.query({
#     select: "ALL_ATTRIBUTES",
#     key_condition_expression: "image_id = :id",
#     expression_attribute_values: {
#         ":id" => '0086db38-46ed-4d9f-9cb0-1acbb1f5aa48'
#     }
# })

# query 
# dynamodb = Aws::DynamoDB::Client.new
# params = {
#     table_name: 'idus-api-prod-products',
#     key_condition_expression: "stat = :stat and id = :id",
#     expression_attribute_values: {
#         ":stat" => "ok",
#         ":id" => 1
#     }
# }
# result = dynamodb.query(params)
# puts result.items