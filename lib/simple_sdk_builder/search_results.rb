module SimpleSDKBuilder
class SearchResults

  attr_reader :result_count, :links, :results

  def initialize(response, type)
    @result_count = response.headers['X-Count'].to_s.to_i

    @links = {}
    response.headers['Link'].to_s.split(',').each do |link|
      if link =~ /<(.*)>; rel="(.*)"/
        @links[$2] = $1
      end
    end

    @results = response.build(type)
  end

end
end
