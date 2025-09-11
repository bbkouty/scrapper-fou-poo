# lib/views/menu.rb
require_relative '../app/scraper_service'
require_relative '../app/scrapper'
require_relative 'table_view'
require 'colorize'

class Menu
  @@emails = {}  # initialisation globale

  def self.start
    loop do
      puts "\n====== SCRAPPER FOU POO ======".colorize(:cyan).bold
      puts "\n======= MENU PRINCIPAL =======".colorize(:light_white)
      puts "1. Scraper les emails".colorize(:light_black)
      puts "2. Afficher les résultats".colorize(:light_black)
      puts "3. Sauvegarder en JSON".colorize(:light_black)
      puts "4. Sauvegarder en CSV".colorize(:light_black)
      puts "5. Sauvegarder dans Google Sheets".colorize(:light_black)
      puts "6. Quitter".colorize(:red)
      print "\n👉 Choix : ".colorize(:light_white)

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
        save_to_google
      when 6
        puts "👋 Au revoir !".colorize(:red)
        break
      else
        puts "⚠️ Choix invalide, réessayez.".colorize(:light_red)
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

    def self.save_to_google
      if !File.exist?("config/service_account.json")

        Scrapper.new(@@emails).save_as_spreadsheet
      else
        error_503
    end
end
end
