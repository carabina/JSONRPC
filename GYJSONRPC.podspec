Pod::Spec.new do |s|

  s.name         = "GYJSONRPC"
  s.version      = "0.1.3"
  s.summary      = "A framework of JSON RPC 2.0."
  s.description  = <<-DESC
                    A Framework for send JSON RPC request.
                   DESC
  s.homepage     = "https://github.com/kojirou1994/JSONRPC"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Kojirou" => "Kojirouhtc@gmail.com" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/kojirou1994/JSONRPC.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.swift"

  s.dependence 'GYJSON', '~> 0.1.6'
end
