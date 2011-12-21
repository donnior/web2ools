def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all '.'

class GoogleConsole
    
    include WebTools
    include ConsoleTools
    

    def search(query)
        puts "to be implement search with '#{query}'"
    end

end
