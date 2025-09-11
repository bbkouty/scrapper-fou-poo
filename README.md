# Scrapper Fou POO

## 📝 Description

Ce projet Ruby vous permet de scraper les **emails des mairies de Mayotte** depuis le site [annuaire-mairie.fr](https://www.annuaire-mairie.fr), et de sauvegarder les résultats dans différents formats : JSON, CSV, ou Google Spreadsheet.  

Il est structuré en **POO** avec une architecture propre et modulaire :  

- `ScraperService` → Récupère les emails depuis le site  
- `Scrapper` → Sauvegarde les données en JSON, CSV ou Google Sheets  
- `TableView` → Affiche les emails dans un tableau console  
- `Menu` → Menu interactif pour naviguer dans l’application  
- `main.rb` → Point d’entrée de l’application  

## ⚙️ Installation

1. **Cloner le projet :**

```bash
git clone https://github.com/bbkouty/scrapper-fou-poo.git
cd scrapper-fou-poo
```
2. **Installer les dépendances :**
```bash
bundle install
```

## 🚀 Utilisation
```bash
ruby app.rb
```
## Menu principal :
1. Scraper les emails → récupère tous les emails des mairies.
2. Afficher les résultats → affiche les emails dans un tableau stylé.
3. Sauvegarder en JSON → crée db/emails.json.
4. Sauvegarder en CSV → crée db/emails.csv.
5. Sauvegarder dans Google Sheets → crée un spreadsheet Google (optionnel).
6. Quitter → ferme l’application.

## 💻 Structure du projet
```
ruby-scrapper-poo/
├── lib/
│   ├── app/
│   │   ├── scraper_service.rb
│   │   └── scrapper.rb
│   └── views/
│       ├── menu.rb
│       └── table_view.rb
├── db/
│   ├── emails.csv
│   └── emails.json
├── config/
│   └── service_account.json
├── spec/
│   ├── spec_helper.rb
│   ├── scraper_service_spec.rb
│   ├── scrapper_spec.rb
│   ├── table_view_spec.rb
│   └── menu_spec.rb
├── app.rb
├── Gemfile
├── Gemfile.lock
└── README.md

```

## 🛠 Technologies
- Ruby
- Nokogiri (HTML parsing)
- Open-URI (requêtes HTTP)
- CSV, JSON
- Colorize (console stylée)

## ⚠️ Notes
- Les emails sont protégés par Cloudflare et sont décodés automatiquement.
- L’option Google Sheets peut afficher un message 503 si le service est indisponible.

## Contribution
Les contributions sont les bienvenues ! Veuillez soumettre une pull request ou ouvrir une issue pour toute suggestion ou amélioration.

## ✨ Auteur
- [SOUARE](https://github.com/bbkouty)