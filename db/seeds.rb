# coding: utf-8
require "csv"

CSV.foreach('db/stations.csv') do |row|
  Station.create(id: row[0], name_ja: row[1], name_en: row[2])
end

CSV.foreach('db/distance.csv') do |row|
  Distance.create(id: row[0], s_id: row[1], g_id: row[2], meter: row[3])
end
