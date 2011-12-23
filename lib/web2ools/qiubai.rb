
class QiuBaiConsole
    
    include WebTools
    include ConsoleTools
    
    def url_with_mode(page)
        if mode == "24"
            "http://www.qiushibaike.com/new2/hot/20/page/#{page}"
        elsif mode == "8"
            "http://www.qiushibaike.com/new2/8hr/20/page/#{page}"
        else
            "http://www.qiushibaike.com/new2/8hr/20/page/#{page}"
        end
    end
    
    def mode
        @mode ? @mode : "24"
    end

    def run_with_mode
        print "Please input mode: 8 => latest, 24 => 24hours :"
        @mode = gets.chomp
        puts "\n\n#{'***********' * 10}\n\n"        
        run
    end

    def run
        @page = @page ? @page + 1 : 1
        url = url_with_mode @page
        articles = list_articles_in_page(url)
        iterate_articles_with_command articles
        run
    end
    
    def list_articles_in_page(url)
        extract_articles_from_doc(open_html_doc(url))
    end
    
    def iterate_articles_with_command(articles)
        puts "\n#{'***********' * 10}\n\n"
        articles.each do |a|
            print_item a
            # print "-------------\n: q => quit, o => open image, * => next :"
            ch = get_cmd_char
            if ch == 'o' && a[:image]
                system("open #{a[:image]}")
                ch = get_cmd_char
            end
            if ch == 'q'
                puts "\nquit the qiubai console ........."
                exit 1
            end
        end
    end
    
    def extract_articles_from_doc(doc)
        articles = []
        doc.css("div.block").each do |link|
            articles << transform(link)
        end
        articles
    end

    def  transform(node)            
        c_map = {}

        content_div = css_first(node, "div.content")
        content_div.children.each do |child|  
              child.replace(Nokogiri::XML::Text.new("\n", child.document)) if child.name == 'br'
        end
        content = content_div.content
        c_map[:content] = content

        author = css_first(node, "div.author a")
        c_map[:author] = author.content.strip! if author

        img = css_first(node, "div.thumb img")
        c_map[:image] = img["src"] if img
        
        tags = css_first(node, "div.tags")
        c_map[:tags] = tags.content.split("\n").reject{|t| t.strip! } if tags
        
        c_map
    end

    def print_item(a)
        puts "#{a[:content]} \n"
        puts "\n[image] #{a[:image]} \n" if a[:image]
        print "\n#{a[:tags]}" if a[:tags]
        print "\t(#{a[:author]})" if a[:author]
        puts "\n\n#{'***********' * 10}\n\n"
    end
end
