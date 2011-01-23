require 'nokogiri'
require 'wolfram/xml_container'
require 'wolfram/util'
require 'wolfram/query'
require 'wolfram/result'
require 'wolfram/pod'
require 'wolfram/assumption'

module Wolfram
  extend self
  
  DefaultQueryURI = "http://api.wolframalpha.com/v2/query"
  
  attr_accessor :appid, :query_uri
  
  def query_uri
    @query_uri ||= DefaultQueryURI
  end
  
  def query(input, options = {})
    Query.new(input, options)
  end
  
  def fetch(input, options = {})
    query(input, options).fetch
  end
  
  def run(argv=ARGV)
    return puts("wolfram QUERY") if argv.empty?
    puts fetch(argv.join(' ')).inspect
  end

  class MissingNodeError < RuntimeError; end
end

Wolfram.appid = ENV['WOLFRAM_API_KEY']
