#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.troester.com/gym/"
url = "http://www.troester.com/gym/MenuW.asp"

assignment_path = '//*[@id="table2"][1]/tr[2]'
judges_path = '//*[@id="table2"][2]/tr[position()>1]'

schedules = CSV.open("csv/schedules.csv","r")
assignments = CSV.open("csv/assignment.csv","w")
judges = CSV.open("csv/judges.csv","w")

schedules.each do |schedule|

  team_id = schedule[0]
  meet_number = schedule[1]
  url = schedule[13]

  if (url==nil)
    next
  end

  begin
    page = agent.get(url)
  rescue
    print "  -> error, retrying\n"
    retry
  end

  page.parser.xpath(assignment_path).each do |tr|
    row = [team_id, meet_number]

    tr.xpath("td").each_with_index do |td,j|
      text = td.text.scrub.strip rescue nil
      row += [text]
    end
    if (row.size > 3)
      assignments << row
    end
  end
  assignments.flush

  page.parser.xpath(judges_path).each do |tr|
    row = [team_id, meet_number]

    tr.xpath("td").each_with_index do |td,j|
      text = td.text.scrub.strip rescue nil
      row += [text]
    end
    if (row.size > 3)
      judges << row
    end
  end
  judges.flush

end

assignments.close
judges.close
