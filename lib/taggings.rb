class Tagging < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      foreign_key :post_id, :table => :posts
      foreign_key :tag_id, :table => :tags
    end
    create_table
  end

  many_to_one :post
  many_to_one :tag
end
