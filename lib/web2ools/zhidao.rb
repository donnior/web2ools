#!/usr/bin/env ruby
#encoding: UTF-8

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
      print_item transform(t)
    end
  end
  
  def transform(node)
      # (node.xpath('div//text()') - node.xpath('div//a//text()')).each do |v|
      #   print v.text.split.join.gsub(/\r/,"").gsub(/\n/,"")
      # end

      text = (node.xpath('div//text()') - node.xpath('div//a//text()')).text.gsub(/\r/,"").gsub(/\n/,"")
      time = text.split("最佳").first.slice(1..-1).gsub(/\t/,"").slice(1..-4)
    {
      :title => css_first(node,"a").text,
      :summary => node.css("span").text,
      :time => time
    }
  end

  def print_item(entity)
    puts "#{'--------------------------' * 5}"
    puts "[ title2 ]  " + entity[:title] +" \t\t@#{entity[:time]}"
    puts "\n[ summary ]  "+entity[:summary]
  end
  
end
