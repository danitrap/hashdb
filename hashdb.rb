#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'net/http'

def hash_search( query )
  #gets the json output from goog.li servers
  url = "http://goog.li/?j=#{URI.encode(query)}"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  #it conforms it with ruby's arrays
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
  $stderr.puts("No matching records found for #{query}.")
  exit
end

puts "Input type: #{results["type"]}."

if (results["type"] != "cleartext")
  #if the argument is an hash just output the clear text
  puts "Clear text: " + results["hashes"]["cleartext"]
else
  #or if it is clear text let's oputput all the matching hashes!
  results["hashes"].each do |entry|
    if (entry[0] != "cleartext")
      puts "" + entry[0].upcase + " " + entry[1]
     end
  end
end

puts "Found in #{results["time"]} ms."