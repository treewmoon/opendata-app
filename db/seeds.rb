# coding: utf-8
require "csv"

CSV.foreach('db/stations.csv') do |row|
  Station.create(id: row[0], name_ja: row[1], name_en: row[2])
end
