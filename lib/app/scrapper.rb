# lib/app/scrapper.rb
require 'json'
require 'csv'
require 'google_drive'
require 'colorize'

class Scrapper
  attr_reader :emails

  def initialize(emails)
    @emails = emails
  end

  def save_as_json(file_path = 'db/emails.json')
    File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(@emails)) }
    puts "💾 JSON sauvegardé → #{file_path}".colorize(:green)
  end

  def save_as_csv(file_path = 'db/emails.csv')
    CSV.open(file_path, 'w') do |csv|
      csv << ['Ville', 'Email']
      @emails.each { |ville, email| csv << [ville, email] }
    end
    puts "💾 CSV sauvegardé → #{file_path}".colorize(:green)
  end

  def save_as_spreadsheet(spreadsheet_name = "Emails Mairies Mayotte")
    session = GoogleDrive::Session.from_service_account_key("config/service_account.json")
    ws = session.create_spreadsheet(spreadsheet_name).worksheets[0]

    ws[1, 1] = "Ville"
    ws[1, 2] = "Email"

    @emails.each_with_index do |(ville, email), index|
      ws[index + 2, 1] = ville
      ws[index + 2, 2] = email
    end

    ws.save
    puts "💾 Spreadsheet Google sauvegardé : #{spreadsheet_name}"
  end
end
