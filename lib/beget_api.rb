# frozen_string_literal: true

require 'net/http'
require 'json'

module Beget
  ##
  # Beget API wrapper
  class API
    API_URI = 'https://api.beget.com/api'

    def initialize(login, password)
      @login = login
      @password = password
    end

    def method_missing(method)
      Section.new(self, method)
    end

    def respond_to_missing?(method, _)
      true
    end

    def request(section, method, **data)
      query = {
        login: @login,
        passwd: @password,
        output_format: 'json'
      }

      unless data.empty?
        query.merge!(
          {
            input_format: 'json',
            input_data: JSON.generate(data)
          }
        )
      end

      uri = "#{API_URI}/#{section}/#{method}?#{URI.encode_www_form(query)}"

      response = Net::HTTP.get_response(URI(uri))
      raise HTTPError, response.code unless response.is_a?(Net::HTTPSuccess)

      response_data = JSON.parse(response.body)
      if response_data['status'] == 'error'
        raise RequestError.new(
          response_data['error_code'],
          response_data['error_text']
        )
      end

      raise AnswerError, response_data['answer']['errors'] if response_data['answer']['status'] == 'error'

      response_data['answer']['result']
    end
  end

  ##
  # Describes API section
  class Section
    def initialize(api, section)
      @api = api
      @section = section
    end

    def method_missing(method, **args)
      @api.request(@section, method, **args)
    end

    def respond_to_missing?
      true
    end
  end

  ##
  # Raises when the server responds with non successful code
  class HTTPError < StandardError; end

  ##
  # General method error
  class RequestError < StandardError
    attr_reader :code, :text

    def initialize(code, text)
      super()
      @code = code
      @text = text
    end

    def to_s
      %(#{@code}: #{@text})
    end
  end

  ##
  # Answer error
  class AnswerError < StandardError
    attr_reader :errors

    def initialize(errors)
      super()
      @errors = errors
    end

    def to_s
      @errors.map { |e| %(#{e['error_code']}: #{e['error_text']}) }.join('; ')
    end
  end
end
