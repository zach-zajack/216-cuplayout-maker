require "open-uri"

module WebParser
  module_function

  PATH = "#{__dir__}/cuplayout.cup"

  def open_website(url)
    begin
      return open(url).read
    rescue
      puts "404'd. Trying again..."
      open_website(url)
    end
  end

  def parse(html, bound_search, index_search=nil, rindex_search)
    index_search ||= bound_search
    bound  = html.index(bound_search)
    return if bound.nil?
    index  = html.index(index_search, bound) + index_search.length
    rindex = html.index(rindex_search, index)
    return html[index...rindex]
  end
end
