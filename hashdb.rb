#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'net/http'

def hash_search( query )
  url = "http://goog.li/?j=#{URI.encode(query)}"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  result = JSON.parse(data)
	
  return result
end


if (!(query = ARGV.shift))
  $stderr.puts("Usage: #{File.basename($0)} hash\n")
  exit
end

puts "Searching for #{query}..." 

results = hash_search( query )
if (results["found"] == "false")
  $stderr.puts("\033[31mNo matching records found for #{query}.\033[0m")
  exit
end

puts "Input type: #{results["type"]}."



if (results["type"] != "cleartext")
  puts "\033[32mClear text: \033[0m" + results["hashes"]["cleartext"]
else
  results["hashes"].each do |entry|
    if (entry[0] != "cleartext")
      puts "\033[32m" + entry[0].upcase + "\033[0m: " + entry[1]
     end
  end
end

puts "Found in #{results["time"]} ms."