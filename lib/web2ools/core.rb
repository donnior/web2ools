require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "highline/system_extensions"
include HighLine::SystemExtensions

module WebTools
    
    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) 
    AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
    
    def open_html_doc(url, encoding="UTF-8")
        puts "************* \t open url from #{url}"
        Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT), nil, encoding)
    end
    
    def css_first(node, css)
        e = node.css(css)
        e.empty? ? nil : e.first
    end
    
    def xpath_first(node, xpath)
        e = node.xpath(xpath)
        e.empty? ? nil : e.first
    end
    
    def trim(s)
        s.strip! || s if s
    end
end

module ConsoleTools
    def get_cmd_char
        get_character.chr
    end
end

