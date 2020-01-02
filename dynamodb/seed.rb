require 'csv'
require 'aws-sdk'

dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
table = dynamodb.table('hwahae-api-dev-product')

product_list = CSV.parse(File.read('hwahae-items.csv'), headers: true)
product_list.each do |product|
    table.put_item({
        item: {
            image_id: product["image_id"],
            url: product["url"],
            name: product["name"],
            price: product["price"]
        }
    })
    puts(product["name"] + ' 추가 성공 !!')
end