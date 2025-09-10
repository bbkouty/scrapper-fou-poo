# spec/scrapper_spec.rb
require 'spec_helper'
require 'fileutils'
require_relative '../lib/app/scrapper'

RSpec.describe Scrapper do
  let(:emails) { { "MAMOUDZOU" => "contact@mamoudzou.fr" } }
  let(:scrapper) { Scrapper.new(emails) }

  after(:each) do
    FileUtils.rm_f(['db/emails.json', 'db/emails.csv'])
  end

  it 'sauvegarde en JSON' do
    scrapper.save_as_json('db/emails.json')
    expect(File.exist?('db/emails.json')).to be true
  end

  it 'sauvegarde en CSV' do
    scrapper.save_as_csv('db/emails.csv')
    expect(File.exist?('db/emails.csv')).to be true
  end
end
