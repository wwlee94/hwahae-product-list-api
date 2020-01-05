class Product < ApplicationItem
    partition_key "stat"
    column :id, :title, :price, :full_size_image, :thumbnail_image, :description, :oily_score, :dry_score, :sensitive_score

    # include Aws::Record
    # integer_attr :id , range_key: true
    # string_attr :stat , hash_key: true 
    # string_attr :title
    # string_attr :seller 
    # string_attr :thumbnail_520
    # string_attr :thumbnail_720
    # string_attr :thumbnail_list_320
    # string_attr :cost
    # string_attr :discount_cost
    # string_attr :discount_rate
    # string_attr :description
end
