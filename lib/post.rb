class Post < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      string      :title
      text        :content
      DateTime    :created_at
      DateTime    :updated_at
    end
    create_table
  end

  one_to_many :taggings
  many_to_many :tags, :join_table => :taggings

  def before_create
    self.created_at = DateTime.now
  end

  def before_save
    self.updated_at = DateTime.now
  end

  def validate
    errors[:title] << "can't be empty" if title.empty?
    errors[:content] << "can't be empty" if content.empty?
  end

  def url
    "/post/#{id}"
  end

  # ===============================================
  # tagging
  # refer to acts_as_taggable_on_steroids
  # ===============================================
  def after_save
    save_tags
  end

  def tag_list
    return @tag_list if @tag_list

    if self.id
      @tag_list = tags.map{ |tag| tag.name }
    else
      @tag_list = ''.to_a
    end
  end

  def tag_list=(value)
    case value
    when Array
      @tag_list = value
    else
      string = value.to_s.dup
      @tag_list = string.split(Tag.delimiter)
    end
  end

  def save_tags
    return unless @tag_list

    new_tag_names = @tag_list - tags.map{ |tag| tag.name }
    old_tags = tags.reject { |tag| @tag_list.include?(tag.name) }

    db.transaction do
      if old_tags.any?
        taggings_dataset.filter(:tag_id => old_tags.map{ |tag| tag.id }).each do |tag|
          tag.destroy
        end
      end
      
      new_tag_names.each do |tag_name|
        self.add_tag Tag.find_by_name_or_create(tag_name)
      end
    end
    true
  end
end
