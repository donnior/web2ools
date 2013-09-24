
class QiuBaiConsole
    
    include WebTools
    include ConsoleTools

    NameColor = "\e[33m"
    CommandColor = "\e[36m"
    DefaultColor = "\e[0m"
    ErrorColor = "\e[31m"
    SpliterColor = "\e[34m"
    
    def url_with_mode(page)
        "http://www.qiushibaike.com/#{mode_link}/page/#{page}"
    end
    
    def mode
        @mode ? @mode : "24"
    end

    def mode_link
        mapping = { "24" => "hot", "8" => "8hr", "w" => "week", "m" => "month" }
        mapping[mode] || "hot"
    end

    def run_with_mode
        print "Please input mode: h => hot, 8 => 8hr, 24 => 24hours, w => week, m => month :"
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
        open_html_doc(url).css("div.block").collect do |link|
            transform(link)
        end
    end
    
    def iterate_articles_with_command(articles)
        articles.each do |a|
            print_item a
            
            print "\n >>>>> q => quit, o => open image, * => next : "

            require 'io/console'
            ch = STDIN.getch
            print "\r"
            puts "#{' ' * 50}"
            $stdout.flush
            
            if ch == 'o' && a[:image]
                system("open #{a[:image]}")
                print " >>>>> q => quit, * => next : "
                ch = STDIN.getch
                print "\r"
                puts "#{' ' * 100}"
                $stdout.flush
            end
            if ch == 'q'
                puts "\nquit the qiubai console ........."
                exit 1
            end

        end
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
        print "#{SpliterColor}#{'***********' * 10}#{DefaultColor}"
        if a[:content] && !a[:content].empty?
            print "#{DefaultColor}#{a[:content].chomp}" 
        end
        if a[:image]
            puts "#{CommandColor}[image] #{a[:image]}" if a[:image]
        end 

        if a[:author]
            puts "\n#{NameColor}(#{a[:author]})"
        end

        
        print "#{SpliterColor}#{' ' * 10}#{DefaultColor}"
    end
end
