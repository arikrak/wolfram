module Wolfram
  class Result
    include XmlContainer
    include Enumerable
    extend Util
    
    delegate :[], :each, :to => :pods
    delegate :uri, :to => :query
    
    attr_reader :assumptions, :pods, :query
    
    def initialize(xml, options = {})
      @query = options[:query]
      @xml = Nokogiri::XML(xml.to_s).search('queryresult').first
      @xml or raise MissingNodeError, "<queryresult> node missing from xml: #{xml[0..20]}..."
      @assumptions = Assumption.collection(@xml, options)
      @pods = Pod.collection(@xml, options)
      types.each {|mod| extend mod}
    end
    
    def successful?
      success
    end
    
    # shortcut to the first assumption
    def assumption
      assumptions[0]
    end
    
    def types
      @types ||= xml['datatypes'].split(',').map {|type| Util.module_get(Result, type)}
    end
    
    def inspect
      out = "a: #{xml['datatypes']}"
      out << " (assumptions: #{assumptions.map(&:name).join(', ')})" if !Array(assumptions).empty?
      out << pods.map{|pod| "\n  - #{pod.to_s.gsub("\n", "\n    ")}"}.join
      out
    end
    
    def format
      @query && @query.options[:format]
    end
  end
end
