#!/usr/bin/env ruby
#encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def open_doc(url, encoding="UTF-8")
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2
     (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
    Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, encoding)
end

def locate_target_view(doc)
    r = doc.css("html head meta[http-equiv='Refresh']").first
    r['content'].split("URL=")[1]    
end

def is_succed_view(view)
    view.match /^\/view/
end

def encoded_query_url(keyword)
    kw = URI.encode(keyword)
    "http://zhidao.baidu.com/q?word=java&lm=0&fr=search&ct=17&pn=0&tn=ikaslist&rn=10"    
end

def css_first(node, css)
    e = node.css(css)
    e.empty? ? nil : e.first
end

def extract_entity_from_doc(doc)
    {
           :summary => css_first(doc, "#sec-content0 .mod-top .card-summary-content").text,
           :info => css_first(doc, "#sec-content0 .mod-top .card-info-inner").text,
           :detail => css_first(doc, "#sec-content0 #lemmaContent-0").text
    }
end

def print_entity(map)
    puts "---------summary \n + #{map[:summary]}"
    puts "---------info \n + #{map[:info]}"
    puts "---------detail \n + #{map[:detail]}"
end

kw = "java"
case ARGV.size
    when 1
    kw = ARGV[0]
end

query_url = encoded_query_url(kw)
doc = open_doc(query_url, "gb2312")

doc.xpath("//div[@id='center']/table[position()>1]/tr/td[@class='f']").each do |t|
   puts t.css("span").text 
end
