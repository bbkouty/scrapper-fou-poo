# spec/scraper_service_spec.rb
require 'spec_helper'
require_relative '../lib/app/scraper_service'

RSpec.describe ScraperService do
  describe '.fetch_emails' do
    it 'retourne un hash' do
      emails = ScraperService.fetch_emails
      expect(emails).to be_a(Hash)
    end

    it 'contient des clés et des valeurs valides' do
      emails = ScraperService.fetch_emails
      unless emails.empty?
        key, value = emails.first
        expect(key).to be_a(String)
        expect(value).to match(/\A[^@\s]+@[^@\s]+\z/)
      end
    end
  end
end
