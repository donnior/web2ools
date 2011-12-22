
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'web2ools'

# require 'web2ools/core'
# require 'web2ools/zhidao'
# require 'web2ools/qiubai'
# require 'web2ools/google'


module WebTools
  VERSION = '0.0.1'
end