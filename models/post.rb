require 'sequel'
Sequel::Model.plugin(:schema)
Sequel.connect('sqlite://db/potage.db')

class Post < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      string      :title
      text        :body
      timestamp   :created_at
      timestamp   :updated_at
    end
    create_table
  end

  def before_create
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def before_save
    self.updated_at = Time.now
  end

  def validate
    errors[:title] << "can't be empty" if title.empty?
    errors[:body] << "can't be empty" if body.empty? || body.split('').length > 1000
  end

  def formatted_body
    self.body && self.body.gsub(/\r\n/, "\n").gsub(/\n/, '<br />')
  end
end
