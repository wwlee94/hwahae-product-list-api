class ProductsController < ApplicationController
  # GET /products
  def index
    dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
    table = dynamodb.table('hwahae-api-dev-product')

    scan_output = table.scan({
      limit: 10,
      select: "ALL_ATTRIBUTES"
    })

    scan_output.items.each do |item|
        keys = item.keys
        keys.each do |k|
            puts "#{k} : #{item[k]}"
            puts item[k].class
        end
    end
    render json: JSON.pretty_generate(scan_output.items);
  end

  # GET /products/1
  def show
    render json: JSON.pretty_generate('hello show');
  end
end
