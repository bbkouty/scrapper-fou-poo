# lib/views/table_view.rb
class TableView
  def self.display(emails)
    return puts "⚠️ Aucun email à afficher".colorize(:red) if emails.empty?

    puts "\n=== LISTE DES EMAILS SCRAPÉS ==="
    puts "-" * 50
    puts "| %-25s | %-20s " % ["Ville", "Email"]
    puts "-" * 50

    emails.each do |ville, email|
      puts "| %-25s | %-20s " % [ville, email]
    end

    puts "-" * 50
    puts "Total : #{emails.size} mairies"
  end
end
