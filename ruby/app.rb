require 'appguard'
require 'functions_framework'
require 'net/http'

FunctionsFramework.http('demo_ruby') do |request|
  Net::HTTP.get_response(URI('https://www.google.com'))
  "Go Appguard!\n"
end