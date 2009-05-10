feed_url = base_url + "/feed"

xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :'xml:lang' => 'ja-JP', :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.id base_url
  xml.link :type => 'text/html', :href => base_url, :rel => 'alternate'
  xml.link :type => 'application/atom+xml', :href => feed_url, :rel => 'self'
  xml.title Blog.title
  xml.subtitle Blog.description
  xml.updated(@posts.first ? rfc_date(@posts.first.updated_at) : rfc_date(Time.now.localtime))
  xml.author { xml.name Blog.author }
  @posts.each do |post|
    xml.entry do |entry|
      entry.id "#{base_url}/post/#{post.id}"
      entry.link :type => 'text/html', :href => "#{base_url}/post/#{post.id}", :rel => 'alternate'
      entry.title post.title
      entry.published rfc_date(post.created_at)
      entry.updated rfc_date(post.updated_at)
      entry.content h(post.content), :type => 'html'
      entry.summary h(post.content), :type => 'html'
      entry.author do |author|
        author.name  Blog.author
      end
    end
  end
end
