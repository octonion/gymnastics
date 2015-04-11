#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

url = "http://www.troester.com/gym/MenuW.asp"

results = CSV.open("csv/teams.csv","w")

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

path='//*[@id="table3"]/tr/td/select/option[position()>1]'

page.parser.xpath(path).each do |option|
  team_id = option.attributes["value"].value
  team_name = option.inner_text
  results << [team_id,team_name]
  results.flush
end

results.close
