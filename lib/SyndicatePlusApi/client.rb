# -*- coding: utf-8 -*-
require 'rexml/document'
require 'crack/json'
require 'cgi'
require 'base64'
require 'uuid'
require 'rest-client'
require 'json'
require 'hashie'
require 'open-uri'

module SyndicatePlusApi
  module Client

    DIGEST  = OpenSSL::Digest::SHA1.new

    # Convenience method to create an SyndicatePlusApi client.
    #
    # An instance is not necessary though, you can simply include the SyndicatePlusApi module otherwise.
    #
    def self.instance
      ins = Object.new
      ins.extend SyndicatePlusApi::Client
      ins
    end

    # Configures the basic request parameters for SyndicatePlusApi.
    #
    # Expects at least +secret+, +key+ and + version number + for the API call:
    #
    #   configure :secret => 'your-secret', :key => 'your-key', :version=> '0/1'
    #
    # See SyndicatePlusApi::Configuration for more infos.
    #

    def configure(options={})
      Configuration.configure(options)
    end


    # Performs an +Product Search By Id + REST call against the SyndicatePlus API.
    #
    #   item = getProductById 5798
    #   Where item  is product fetched from SyndicatePlus using Id
    #

    def getProductById(productId)
      params = {}
      path = "/products/product/#{productId}"
      method = 'GET'
      product = call(method, params, path)
      product = convert_to_object(product)
      product
    end


    # Performs an +Product Search By Ean + REST call against the SyndicatePlus API.
    #
    #   item = getProductByEan 'Unox'
    #   Where item  is product fetched from SyndicatePlus using Ean
    #

    def getProductByEan(ean)
      params = {:ean => ean}
      path = "/products/product"
      method = 'GET'
      product = call(method,params, path)
      product = convert_to_object(product)
      product
    end


    # Performs an +Product Search + REST call against the SyndicatePlus API.
    #
    #   items = search 'Unox'
    #   Where items are list of products fetched from SyndicatePlus
    #
    def search_product(productQuery)
      products = []
      params = {:"q=productname" => CGI.escape(productQuery.to_s)}
      path = "/products"
      method = 'GET'
      product_list = call(method,params, path)
      product_list.each do |p|
        products << Hashie::Mash.new(p)
      end
      products
    end

    # Performs an +Brand Search By Id + REST call against the SyndicatePlus API.
    #
    #   item = getBrandById 5798
    #   Where item  is brand fetched from SyndicatePlus using Id
    #

    def getBrandById(brandId)
      params = {}
      path = "/brands/brand/#{brandId}"
      method = 'GET'
      brand = call(method, params, path)
      brand = convert_to_object(brand)
      brand
    end
    # Performs an +Brand Search + REST call against the SyndicatePlus API.
    #
    #   items = search 'Unox'
    #   Where items are list of brands fetched from SyndicatePlus
    #
    def search_brand(brandQuery)
      brands = []
      params = {:"q=name" => CGI.escape(brandQuery.to_s)}
      path = "/brands"
      method = 'GET'
      brand_list = call(method,params, path)
      brand_list.each do |p|
        brands << Hashie::Mash.new(p)
      end
      brands
    end

    # Performs an +manufacturer Search By Id + REST call against the SyndicatePlus API.
    #
    #   item = getmanufacturerById 5798
    #   Where item  is manufacturer fetched from SyndicatePlus using Id
    #

    def getManufacturerById(manufacturerId)
      params = {}
      path = "/manufacturers/manufacturer/#{manufacturerId}"
      method = 'GET'
      manufacturer = call(method, params, path)
      manufacturer = convert_to_object(manufacturer)
      manufacturer
    end


# Performs an +manufacturer Search By Ean + REST call against the SyndicatePlus API.
#
#   item = getmanufacturerByEan 'Unox'
#   Where item  is manufacturer fetched from SyndicatePlus using Ean
#

    def getManufacturerByEan(ean)
      params = {:ean => ean}
      path = "/manufacturers/manufacturer"
      method = 'GET'
      manufacturer = call(method,params, path)
      manufacturer = convert_to_object(manufacturer)
      manufacturer
    end


    # Performs an +manufacturer Search + REST call against the SyndicatePlus API.
    #
    #   items = search 'Unox'
    #   Where items are list of manufacturers fetched from SyndicatePlus
    #

    def search_manufacturer(manufacturer)
      manufacturers = []
      params = {:"q=name" => CGI.escape(manufacturerQuery.to_s)}
      path = "/manufacturers"
      method = 'GET'
      manufacturer_list = call(method,params, path)
      manufacturer_list.each do |m|
        manufacturers << Hashie::Mash.new(m)
      end
      manufacturers
    end

    def getNutrients
      path = "/nutrients"
      params={}
      method = 'GET'
      nutrient_list = call(method,params, path)
      nutrient_list.each do |n|
        nutrients << Hashie::Mash.new(n)
      end
      nutrients
    end

    def get_allergens
      path = "/allergens"
      params={}
      method = 'GET'
      allergen_list = call(method,params, path)
      allergen_list.each do |a|
        allergens << Hashie::Mash.new(a)
      end
      allergens
    end


    private

   def convert_to_object(response)
     Hashie::Mash.new(response)
   end

  def call(method, params, path)
    Configuration.validate!

    log(:debug, "calling with params=#{params}")
    signed = create_signed_query_string(method,params, path)

    url = "#{buildApiEndPoint(Configuration.host,path,Configuration.version)}?#{create_query(params)}"
    log(:info, "performing rest call to url='#{url}'")
    #response = RestClient.get(url, {:content_type => "application/x-www-form-urlencode", :accept => :json})
    response = open(url,
                    "header" => "Authorization: "+ signed +"\r\n"+"Content-Type: application/x-www-form-urlencode\r\n").read()
      resp = response
      resp = resp.force_encoding('UTF-8') if resp.respond_to? :force_encoding
      log(:debug, "got response='#{resp}'")
      productJson = Crack::JSON.parse(resp)
  end

    def create_signed_query_string(method, params, path)
      # utc timestamp needed for signing
      key = Configuration.key
      timestamp = Time.now.utc.to_i
      nonce = UUID.new.generate

      query = create_query(params)

      # yeah, you really need to sign the get-request not the query
      endPoint = buildApiEndPoint(Configuration.host, path, Configuration.version)
      request_to_sign = "#{Configuration.secret}+#{method}+#{endPoint}+#{query}+#{nonce}+ #{timestamp}"
      hmac = DIGEST.digest(request_to_sign)
      # don't forget to remove the newline from base64
      signature = CGI.escape(hmac.chomp)
      header = "Key=\""+ key +"\",Timestamp=\""+ "#{timestamp}" +"\",Nonce=\""+ "#{nonce}" +"\",Signature=\""+ signature +"\""
      log(:debug, header)
      header
    end

    def create_query(params)
      params.map do |key, value|
        value = value.collect{|v| v.to_s.strip}.join(',') if value.is_a?(Array)
        "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
      end.sort.join('&').gsub('+','%20') # signing needs to order the query alphabetically
    end

    def log(severity, message)
      Configuration.logger.send severity, message if Configuration.logger
    end


    def buildApiEndPoint(host, path, version)
       request_path = ''
       request_path.concat(host)
       if(!request_path.include? "/v#{version}")
         request_path = request_path.concat("/v#{version}")
       end
         request_path.concat(path)
      request_path
    end
  end
end

