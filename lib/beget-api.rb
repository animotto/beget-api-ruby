require "net/http"
require "json"

module Beget
  class API
    API_URI = "https://api.beget.com/api"

    def initialize(login, password)
      @login = login
      @password = password
    end

    def method_missing(method)
      Section.new(self, method)
    end

    def request(section, method, **data)
      query = {
        login:          @login,
        passwd:         @password,
        output_format:  "json",
      }

      data.delete_if {|k, v| v.nil?}
      query.merge!({
        input_format: "json",
        input_data:   JSON.generate(data),
      }) unless data.empty?

      uri = [
        API_URI,
        section,
        method,
      ].join("/") + "?" + URI.encode_www_form(query)

      response = Net::HTTP.get_response(URI(uri))
      raise HTTPError, response.code unless response.is_a?(Net::HTTPOK)

      response_data = JSON.parse(response.body)
      raise RequestError.new(
        response_data["error_code"],
        response_data["error_text"]
      ) if response_data["status"] == "error"

      raise AnswerError.new(
        response_data["answer"]["errors"],
      ) if response_data["answer"]["status"] == "error"

      response_data["answer"]["result"]
    end
  end

  class Section
    def initialize(api, section)
      @api = api
      @section = section
    end

    def method_missing(method, **args)
      @api.request(@section, method, **args)
    end
  end

  class HTTPError < StandardError; end

  class RequestError < StandardError
    attr_reader :code, :text

    def initialize(code, text)
      @code = code
      @text = text
    end

    def to_s
      %Q[#{@code}: #{@text}]
    end
  end

  class AnswerError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def to_s
      @errors.map {|e| %Q[#{e["error_code"]}: #{e["error_text"]}]}.join("; ")
    end
  end
end

