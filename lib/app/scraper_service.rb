# lib/app/scraper_service.rb
require 'nokogiri'
require 'open-uri'

class ScraperService
  BASE_URL = "https://www.annuaire-mairie.fr/departement-mayotte.html"
  OPTIONS = { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }

  def self.fetch_emails
    emails = {}

    doc = Nokogiri::HTML(URI.open(BASE_URL, OPTIONS))

    doc.css('table.tblmaire tbody tr').each do |row|
      link = row.at_css('td a')
      next unless link

      ville_name = link.text.strip.upcase
      ville_url  = "https://www.annuaire-mairie.fr#{link['href']}"

      begin
        ville_page = Nokogiri::HTML(URI.open(ville_url, OPTIONS))
        encoded_email = ville_page.at_css('span.__cf_email__')&.[]('data-cfemail')

        if encoded_email
          email = decode_cf_email(encoded_email)
          emails[ville_name] = email
          puts "✅ #{ville_name} → #{email}".colorize(:green)
        else
          puts "⚠️ Aucun email trouvé pour #{ville_name}"
        end
      rescue => e
        puts "❌ Erreur pour #{ville_name} : #{e.message}"
      end
    end

    emails
  end

  private

  def self.decode_cf_email(encoded_string)
    bytes = [encoded_string].pack('H*').bytes
    key = bytes[0]
    decoded = bytes[1..-1].map { |b| (b ^ key).chr }.join
    decoded
  end
end
