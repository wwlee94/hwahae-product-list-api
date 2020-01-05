require 'aws-sdk'
dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
table = dynamodb.table('hwahae-api-prod-products')

# index sort & filter 
page = 2
filter = '10'

params = {
    index_name: 'dry_score_index',
    key_condition_expression: 'stat = :stat',
    filter_expression: 'contains (title, :word)',
    expression_attribute_values: {
        ':stat' => 'ok',
        ':word' => filter
    },
    projection_expression: 'image_id, full_size_image, title, price, oily_score, dry_score, sensitive_score',
    scan_index_forward: false, # false면 내림차순, true면 오름차순
    # limit: 20
}

begin
    # index dry_score desc
    @products = table.query(params)

    @products = @products.items.slice((page-1)*20, 20)
    puts @products
    puts @products.length
    puts "요청된 페이지 = #{page}"
    
rescue  Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to scan:"
    puts "#{error.message}"
end

# # 페이징, index sorting
# page = 50

# params = {
#     index_name: 'dry_score_index',
#     key_condition_expression: "stat = :stat",
#     expression_attribute_values: {
#         ":stat" => "ok"
#     },
#     projection_expression: "image_id, full_size_image, title, price, oily_score, dry_score, sensitive_score",
#     scan_index_forward: false, # false면 내림차순, true면 오름차순
#     limit: 20
# }

# loop_count = 1
# begin
#     loop do
#         # index dry_score desc
#         @products = table.query(params)

#         puts "Scanning for more... page = #{loop_count}"

#         break if @products.last_evaluated_key.nil? or (loop_count == page)

#         params[:exclusive_start_key] = @products.last_evaluated_key
#         loop_count += 1
#     end
#     puts @products.items
#     puts @products.last_evaluated_key
#     puts @products.items.length
#     puts "요청된 페이지 = #{page}, 확인된 페이지 #{loop_count}"
    
# rescue  Aws::DynamoDB::Errors::ServiceError => error
#     puts "Unable to scan:"
#     puts "#{error.message}"
# end

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