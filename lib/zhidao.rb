#!/usr/bin/env ruby
#encoding: UTF-8


def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all '.'

class BaiduZhidaoConsole
  
  include WebTools
  include ConsoleTools

  def encoded_query_url(keyword)
    kw = URI.encode(keyword)
    "http://zhidao.baidu.com/q?word=#{kw}&lm=0&fr=search&ct=17&pn=0&tn=ikaslist&rn=10"    
  end

  def run(kw)
    query_url = encoded_query_url(kw)
    doc = open_html_doc(query_url, "gb2312")
    doc.xpath("//div[@id='center']/table[position()>1]/tr/td[@class='f']").each do |t|
      print_entity transform(t)
    end
  end
  
  def print_entity(entity)
    puts "#{'--------------------------' * 5}"
    puts "[ title ]  " + entity[:title]
    puts "[ summary ]  "+entity[:summary]
  end
  
  def transform(node)
    {
      :title => node.css("a").text,
      :summary => node.css("span").text
    }
  end
  
end
