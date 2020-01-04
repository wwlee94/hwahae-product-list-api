class ProductsController < ApplicationController
  
  # GET /products
  def index
    resource = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
    dynamodb = resource.table('hwahae-api-prod-products')

    param = {
      projection_expression: "id, title, seller, thumbnail_520",
      key_condition_expression: "stat = :stat",
      expression_attribute_values: {
        ":stat" => "ok"
      },
      scan_index_forward: false, # false면 내림차순, true면 오름차순
      limit: 20
    }
  
    # 페이지 변수가 있을 때
    if params[:page]
      render json: '페이지 변수 존재'
      # raise Exceptions::ParameterIsNotInteger unless is_number? params[:page]

      # page_no = params[:page].to_i
      # raise Exceptions::PageUnderRequest if page_no <= 0

      # start_id = (params[:page].to_i - 1) * 50

      # puts('Searching for more ...')

      # param[:exclusive_start_key] = {
      #   id: start_id,
      #   stat: "ok"
      # }

      # begin
      #   @products = dynamodb.query(param)
      #   puts @products.items
      #   puts @products.last_evaluated_key
      #   raise Exceptions::PageOverRequest if @products.items.blank?
      #   @products.items.each do |item|
      #     str_int = item['id']
      #     item['id'] = str_int.to_i
      #   end
      #   response = { statusCode: 200, body: @products.items }
      # rescue Aws::DynamoDB::Errors::ServiceError => e
      #   response = { statusCode: 500, body: "#{e.message}" }
      # end

      # raise Exceptions::InternalServerError if response.nil?

      # render json: JSON.pretty_generate(response)
    else
      # 페이지 변수 없을 때 첫 50개 데이터만 보여줌
      begin
        @products = dynamodb.query(param)
        @products.items.each do |item|
          str_int = item['id']
          item['id'] = str_int.to_i
        end
        response = { statusCode: 200, body: @products.items }
      rescue Aws::DynamoDB::Errors::ServiceError => e
        response = { statusCode: 500, body: "#{e.message}" }
      end

      raise Exceptions::InternalServerError if response.nil?
      
      render json: JSON.pretty_generate(response)
    end
  end


  # GET /products/1
  def show
    render json: JSON.pretty_generate('hello show');
  end

  private
    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:image_id, :title, :price, :full_size_image, :thumbnail_image, :description, :oily_score, :dry_score, :sensitive_score, :page, :skin_type)
    end

    def is_number? string
      true if Integer(string) rescue false
    end
end
