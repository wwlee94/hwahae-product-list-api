class ProductsController < ApplicationController
  before_action :set_dynamodb
  before_action :set_product_details, only: [:show]
  
  rescue_from Exceptions::BadRequest, Exceptions::NotFound, Exceptions::InternalServerError do |e|
    response = { statusCode: e.status, body: e.message }
    render json: JSON.pretty_generate(response)
  end

  # GET /products
  def index
    param = {
      key_condition_expression: "stat = :stat",
      expression_attribute_values: {
          ":stat" => "ok"
      },
      projection_expression: "image_id, thumbnail_image, title, price",
      scan_index_forward: false, # false면 내림차순, true면 오름차순
      limit: 20
    }

    raise Exceptions::ValidateSkinTypeParameter if is_number? params[:skin_type]

    case params[:skin_type]
    when nil
      param[:index_name] = 'oily_score_index' 
      param[:projection_expression].concat(',oily_score')
    when 'oily'
      param[:index_name] = 'oily_score_index'
      param[:projection_expression].concat(',oily_score')
    when 'dry'
      param[:index_name] = 'dry_score_index'
      param[:projection_expression].concat(',dry_score')
    when 'sensitive'
      param[:index_name] = 'sensitive_score_index'
      param[:projection_expression].concat(',sensitive_score')
    else
      raise Exceptions::ValidateSkinTypeParameter
    end
  
    # 페이지 변수가 있을 때
    if params[:page]
      raise Exceptions::ValidatePageParameter unless is_number? params[:page]

      render json: '페이지 변수 존재'

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
      # 페이지 변수 없을 때 기본 데이터(20개)만 보여줌
      begin
        products = @dynamodb.query(param)
        products.items.each do |item| 
          skin_type_score = "#{params[:skin_type] || 'oily'}_score"
          item[skin_type_score] = item[skin_type_score].to_i
        end
        response = { statusCode: 200, body: products.items, scanned_count: products.items.length }
      rescue Aws::DynamoDB::Errors::ServiceError => e
        response = { statusCode: 500, body: "#{e.message}" }
      end

      raise Exceptions::InternalServerError if response.nil?
      
      render json: JSON.pretty_generate(response)
    end
  end


  # GET /products/1
  def show
    raise Exceptions::ProductNotFound if @product.items.blank?
    @product.items[0]['oily_score'] = @product.items[0]['oily_score'].to_i
    @product.items[0]['dry_score'] = @product.items[0]['dry_score'].to_i
    @product.items[0]['sensitive_score'] = @product.items[0]['sensitive_score'].to_i
    response = { statusCode: 200, body: @product.items[0] }
    render json: JSON.pretty_generate(response);
  end

  private
    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:image_id, :title, :price, :full_size_image, :thumbnail_image, :description, :oily_score, :dry_score, :sensitive_score, :page, :skin_type)
    end

    def set_dynamodb
      resource = Aws::DynamoDB::Resource.new(region: 'ap-northeast-2')
      @dynamodb = resource.table('hwahae-api-prod-products')
    end

    # 상세 정보
    def set_product_details
      param = {
        projection_expression: "image_id, full_size_image, title, description, price, oily_score, dry_score, sensitive_score",
        key_condition_expression: "stat = :stat and image_id = :id",
        expression_attribute_values: {
          ":stat" => "ok",
          ":id" => params[:id]
        }
      }
      begin
        @product = @dynamodb.query(param)
      rescue Aws::DynamoDB::Errors::ServiceError => error
        response = { statusCode: 500, body: "#{error.message}"} 
        render json: JSON.pretty_generate(response)
      end
    end

    def is_number? string
      true if Integer(string) rescue false
    end
end
