#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.troester.com/gym/"
url = "http://www.troester.com/gym/MenuW.asp"

team_path = '//*[@id="table2"][1]/tr[2]'
individual_path = '//*[@id="table2"][2]/tr[position()>1]'

schedules = CSV.open("csv/ncaa_schedules.csv","r")
team_results = CSV.open("csv/ncaa_team_results.csv","w")
individual_results = CSV.open("csv/ncaa_individual_results.csv","w")

schedules.each do |schedule|

  team_id = schedule[0]
  meet_number = schedule[1]
  url = schedule[2]

  if (url==nil)
    next
  end

  begin
    page = agent.get(url)
  rescue
    print "  -> error, retrying\n"
    retry
  end

  page.parser.xpath(team_path).each do |tr|
    row = [team_id, meet_number]

    tr.xpath("td").each_with_index do |td,j|
      text = td.text.scrub.strip rescue nil
      row += [text]
    end
    team_results << row
  end
  team_results.flush

  page.parser.xpath(individual_path).each do |tr|
    row = [team_id, meet_number]

    tr.xpath("td").each_with_index do |td,j|
      text = td.text.scrub.strip rescue nil
      row += [text]
    end
    individual_results << row
  end
  individual_results.flush

end

team_results.close
individual_results.close
