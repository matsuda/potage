class Tag < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      text        :name
    end
    create_table
  end

  @@delimiter = ' '

  one_to_many :taggings
  many_to_many :posts, :join_table => :taggings

  def validate
    errors[:name] << "can't be empty" if name.empty?
  end

  def self.delimiter
    @@delimiter
  end

  def self.delimiter=(delimiter)
    @@delimiter = delimiter
  end

  def self.find_by_name_or_create(name)
    find(:name => name) || create(:name => name)
  end
end
