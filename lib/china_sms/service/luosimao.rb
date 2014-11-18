# encoding: utf-8

module ChinaSMS
  module Service
    module Luosimao
      extend self

      TO_URL = "https://sms-api.luosimao.com/v1/send.json"
      GET_URL = "https://sms-api.luosimao.com/v1/status.json"

      def to(phone, content, options)
        url = URI.parse(TO_URL)
        post = Net::HTTP::Post.new(url.path)
        post.basic_auth(options[:username], options[:password])
        post.set_form_data({mobile: phone, message: content})

        socket = Net::HTTP.new(url.host, url.port)
        socket.use_ssl = true
        response = socket.start {|http| http.request(post) }
        result JSON.parse(response.body)
      end

      def get(options)
        url = URI.parse(GET_URL)
        get = Net::HTTP::Get.new(url.path)
        get.basic_auth(options[:username], options[:password])
        socket = Net::HTTP.new(url.host, url.port)
        socket.use_ssl = true
        response = socket.start {|http| http.request(get) }
        JSON.parse(response.body)
      end

      def result(body)
        {
          success: body['error'] == 0,
          code: body['error'],
          message: body['msg']
        }
      end
    end
  end
end
