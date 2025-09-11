# lib/app/scrapper.rb
require 'json'
require 'csv'
require 'google_drive'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'colorize'

class Scrapper
  attr_reader :emails

  SHEETS = Google::Apis::SheetsV4
  SCOPE  = ['https://www.googleapis.com/auth/spreadsheets']

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


  def save_as_spreadsheet(sheet_title = "Emails Mairies Mayotte")
    begin
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open("config/service_account.json"),
        scope: SCOPE
      )
      service = SHEETS::SheetsService.new
      service.authorization = authorizer

      # Création de la spreadsheet
      spreadsheet = SHEETS::Spreadsheet.new(properties: { title: sheet_title })
      spreadsheet = service.create_spreadsheet(spreadsheet)
      sheet_id = spreadsheet.spreadsheet_id

      puts "📄 Spreadsheet créé : #{sheet_title} (ID: #{sheet_id})"

      # Nom de la première feuille
      sheet_name = spreadsheet.sheets.first.properties.title

      # Préparer les données
      values = [["Ville", "Email"]] + @emails.map { |ville, email| [ville, email] }
      value_range = SHEETS::ValueRange.new(values: values)

      # Écrire les données dans la feuille
      service.update_spreadsheet_value(
        sheet_id,
        "#{sheet_name}!A1",      # <-- Attention ici
        value_range,
        value_input_option: "RAW"
      )

      puts "💾 Données sauvegardées dans Google Sheets !"
    rescue Google::Apis::ClientError => e
      puts "❌ Client Error : #{e.message}"
    rescue Google::Apis::ServerError => e
      puts "❌ Server Error : #{e.message}"
    rescue => e
      puts "❌ Autre erreur : #{e.message}"
    end
  end


=begin
  def save_as_spreadsheet(spreadsheet_name = "Emails Mairies Mayotte")
    session = GoogleDrive::Session.from_service_account_key("config/service_account.json")
    folder_id = "1TVwFO6GRZ6Z3RovnrZkJj9oI5HAvbYeP"
    folder = session.collection_by_id(folder_id)
    #https://drive.google.com/drive/folders/1TVwFO6GRZ6Z3RovnrZkJj9oI5HAvbYeP?usp=drive_link
    
    if folder.nil?
      puts "⚠️  Dossier 'Scrapper' introuvable. Vérifie que tu l’as bien créé et partagé."
      return
    end

    spreadsheet = folder.create_spreadsheet("Emails Mairies Mayotte")

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
=end
end
