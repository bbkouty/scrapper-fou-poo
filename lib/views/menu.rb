# lib/views/menu.rb
require_relative '../app/scraper_service'
require_relative '../app/scrapper'
require_relative 'table_view'
require 'colorize'

class Menu
  emails = {}  # initialisation globale

  def self.start
    loop do
      puts "\n====== SCRAPPER FOU POO ======".colorize(:light_white)
      puts "\n======= MENU PRINCIPAL =======".colorize(:light_white)
      puts "1. Scraper les emails"
      puts "2. Afficher les résultats"
      puts "3. Sauvegarder en JSON"
      puts "4. Sauvegarder en CSV"
      puts "5. Sauvegarder dans Google Sheets"
      puts "6. Quitter"
      print "👉 Choix : "

      choice = gets.chomp.to_i
      case choice
      when 1
        @@emails = ScraperService.fetch_emails
        puts "✅ Scraping terminé !".colorize(:green)
      when 2
        check_emails
        TableView.display(@@emails)
      when 3
        check_emails
        Scrapper.new(@@emails).save_as_json
      when 4
        check_emails
        Scrapper.new(@@emails).save_as_csv
      when 5
        error_503
        # check_emails
        # Scrapper.new(@@emails).save_as_spreadsheet
      when 6
        puts "👋 Au revoir !".colorize(:blue)
        break
      else
        puts "⚠️ Choix invalide, réessaie.".colorize(:red)
      end
    end
  end

  private

    def self.check_emails
      if !defined?(@@emails) || @@emails.empty?
        puts "⚠️ Tu dois d’abord lancer le scraping (option 1) !".colorize(:red)
        @@emails = {}
      end
    end

    def self.error_503
      puts "\e[31m" + "╔══════════════════════════════════════╗" + "\e[0m"
      puts "\e[31m" + "║        🚨 ERREUR 503 🚨              ║" + "\e[0m"
      puts "\e[31m" + "║  Service temporairement indisponible ║" + "\e[0m"
      puts "\e[31m" + "╚══════════════════════════════════════╝" + "\e[0m"
      puts
      puts "\e[33mConseil:\e[0m Réessayez plus tard service en construction."
      puts
    end
end
