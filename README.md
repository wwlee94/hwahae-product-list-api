# 화해 상품 목록 조회 API 
```
1. 상품 목록을 skin_type에 따라 조회 하거나 특정 Title을 기준으로 검색하며 페이징할 수 있는 API
2. 상품 코드에 따른 상세 정보 조회도 가능합니다.
```
## API Reference

### BASE URL (Deprecated !)
    > BASE URL 뒤에 원하는 리소스를 붙혀 사용합니다.  
    ex) {BASE URL}/products?skin_type=oily&page=5

## Products API - Get 메소드
상품 목록을 조회 할 수 있는 기능 

```
GET /products?skin_type=oily -> 지성 피부에 대한 성분 점수 내림차순으로 상품 목록을 반환합니다. (20개 단위 페이징)

GET /products?skin_type=oily&page={페이지 번호} -> 페이지 번호에 해당되는 상품 목록을 반환합니다. 

GET /products?skin_type=oily&search={검색 키워드} -> 키워드에 해당되는 상품 목록을 반환합니다.
```

#### Request Header 구조
```
GET /products
Content-Type: application/json
```

### 1. 페이징 기능

#### QueryParameter
| Parameter | Type   | Description |
|----------------|--------|-------------|
| skin_type      | String | (선택) 피부 타입 [Default: oily] |
| page           | Integer | (선택) 페이지 번호 |
| search           | String | (선택) 검색 키워드 |

#### 요청 예시 - cURL
```
1. curl -G https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products -H "Content-Type: application/json"

curl -G https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products?skin_type=oily&page=10 -H "Content-Type: application/json"

curl -G https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products?skin_type=dry&search=프랑스 -H "Content-Type: application/json"

2. 웹 브라우저에서 테스트
https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products?skin_type=oily&page=10
```

#### Response Body 예시
```
{
  "statusCode": 200,
  "body": [
    {
      "id": 258,
      "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/2c7672aa-5112-4f28-bd43-79ee817d67bf.jpg",
      "title": "화해 브라이트닝 스킨 케어",
      "price": "23000",
      "{skin_type}_score": 86
    },
    ....
    ....
}
```

#### Response Body 설명
| Column     | Type      | Description   |
|------------|-----------|---------------|
| id       | Integer    | 상품 코드      |
| thumbnail_image | String |  썸네일 이미지 |
| title    | String    | 상품명     |
| price  | String    | 가격     |
| oily_score  | Integer    | 지성 성분 점수     |
| dry_score  | Integer    | 건성 성분 점수     |
| sensitive_score  | Integer    | 민감성 성분 점수     |

### 2. 상세 정보 조회 기능

#### PathParameters
| Parameter | Type   | Description |
|----------------|--------|-------------|
| id        | Integer | 상품 코드 |


#### 요청 예시 - cURL
```
1. curl -G https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products/250 -H "Content-Type: application/json"

2. 웹 브라우저에서 테스트
https://6uqljnm1pb.execute-api.ap-northeast-2.amazonaws.com/prod/products/250
```

#### Response Body 예시
```

  "statusCode": 200,
  "body": {
    "id": 250,
    "full_size_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/image/88acd4f2-765b-4687-930d-c34bfe6aa932.jpg",
    "title": "새라제나 노보스트라타 프리미엄 에멀전 130ml",
    "description": "something description ....",
    "price": "44910",
    "oily_score": 79,
    "dry_score": 49,
    "sensitive_score": 30,
  }
}
```

#### Response Body 설명
| Column     | Type      | Description   |
|------------|-----------|---------------|
| id       | Integer    | 상품 코드      |
| full_size_image | String |  상세 정보 이미지 |
| title | String |  상품명 |
| description | String |  상품 설명 |
| price    | String    | 상품 가격     |
| oily_score  | Integer    | 지성 성분 점수     |
| dry_score  | Integer    | 건성 성분 점수     |
| sensitive_score  | Integer    | 민감성 성분 점수     |

#### Response Status Code
| Status Code               | Description                                       |
|---------------------------|---------------------------------------------------|
| 200 OK                    | 성공                                              |
| 400 Bad Request           | 클라이언트 요청 오류 - page, id 요청 변수가 Integer 형식이 아닐 때, skin_type이 형식에 맞지 않을 때 |
| 404 NotFound              | 조회한 데이터가 비어있을 때, URL 경로, HTTP method 오류로 페이지를 찾을 수 없을 때 |
| 500 Internal Server Error | 서버에 문제가 있을 경우                           |
