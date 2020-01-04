require 'csv'
require 'aws-sdk'

GREPP_S3_URL = 'https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview'

full_size_image = "#{GREPP_S3_URL}/image"
thumbnail_image = "#{GREPP_S3_URL}/thumbnail"

dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
table = dynamodb.table('hwahae-api-dev-product')


product_list = CSV.parse(File.read('hwahae-items.csv'), headers: true)
i = 0
product_list.each do |product|
    description = "";
    for i in 1..10
        break description += product['name'] if i == 10
        description += product['name'] +'\n'
    end
    table.put_item({
        item: {
            image_id: product['image_id'],
            full_size_image: "#{full_size_image}/#{product['image_id']}.jpg",
            thumbnail_image: "#{thumbnail_image}/#{product['image_id']}.jpg",
            name: product['name'],
            price: product['price'],
            description: description,
            oily_score: rand(0..100),
            dry_score: rand(0..100),
            sensitive_score: rand(0..100),
        }
    })
    puts("#{product['name']} 저장 완료 !")
end