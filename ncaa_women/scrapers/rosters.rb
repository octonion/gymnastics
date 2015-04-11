#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.troester.com/gym/"
url = "http://www.troester.com/gym/MenuW.asp"

path = '//*[@id="table2"]/tr[position()>1]'

teams = CSV.open("csv/teams.csv","r")
rosters = CSV.open("csv/rosters.csv","w")

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

form = page.forms[0]

teams.each do |team|

  team_id = team[0]

  form["Team"] = team_id
  page = form.submit

  page.parser.xpath(path).each do |tr|
    row = [team_id]

    tr.xpath("td").each_with_index do |td,j|
      case j
      when 0
        a = td.xpath("a").first
        href = a.attributes["href"].inner_text.scrub.strip rescue nil
        href = base+href rescue nil
        row += [href]
      else
        text = td.text.scrub.strip rescue nil
        row += [text]
      end
    end

    if (row.size > 3)
      rosters << row
    end
  end
  rosters.flush
end

rosters.close
