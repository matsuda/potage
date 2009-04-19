class Post < Sequel::Model
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

  def format_body
    self.body && self.body.gsub(/\r\n/, '\n').gsub(/\n/, '<br />')
  end
end
