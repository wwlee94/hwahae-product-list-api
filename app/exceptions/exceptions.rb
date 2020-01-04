# frozen_string_literal: true

module Exceptions
  class BadRequest < StandardError
    def status
      400
    end
  end

  class NotFound < StandardError
    def status
      404
    end
  end

  class Unauthorized < StandardError
    def status
      401
    end
  end

  class Forbidden < StandardError
    def status
      403
    end
  end

  class InternalServerError < StandardError
    def status
      500
    end
  end

  class ParameterIsNotInteger < BadRequest
    def message
      "ParameterIsNotInteger - 요청 변수가 Integer 타입이 아닙니다!"
    end
  end

  class PageOverRequest < NotFound
    def message
      "PageOverRequest - 요청 페이지를 초과 했습니다!"
    end
  end

  class PageUnderRequest < NotFound
    def message
      "PageUnderRequest - 페이지는 1부터 시작합니다!"
    end
  end

  class ProductNotFound < NotFound
    def message
      "ProductNotFound - 데이터가 비어있습니다!"
    end
  end
end
  