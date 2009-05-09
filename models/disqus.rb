class Disqus
  USERNAME = 'mat5uda' unless self.const_defined?(:USERNAME)

  class << self
    def snippet_1
      %Q{<div id="disqus_thread"></div><script type="text/javascript" src="http://disqus.com/forums/#{USERNAME}/embed.js"></script><noscript><a href="http://#{USERNAME}.disqus.com/?url=ref">View the discussion thread.</a></noscript><a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>}
    end
    alias :comment :snippet_1

    def snippet_2
      <<-SCRIPT
<script type="text/javascript">
//<![CDATA[
  (function() {
    var links = document.getElementsByTagName('a');
    var query = '?';
    for(var i = 0; i < links.length; i++) {
      if(links[i].href.indexOf('#disqus_thread') >= 0) {
        query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
      }
    }
    document.write('<script charset="utf-8" type="text/javascript" src="http://disqus.com/forums/#{USERNAME}/get_num_replies.js' + query + '"></' + 'script>');
    }
  )();
//]]>
</script>
      SCRIPT
    end
  end
end
