require 'net/http'

class Jre_api < ApplicationController
  CONSUMERKEY = "&acl:consumerKey=11c7de08168db1313ebdb42b41ffea8f50a6e7c8688f5585f1c975e08037e44e"
  URL_HEAD = "http://api-tokyochallenge.odpt.org/api/v4/"

  #山手線の運行状況をJSONで返す
  def self.get_location
    body = "odpt:Train?"
    train_type = "odpt:railway=odpt.Railway:JR-East.Yamanote"
    url = URI.parse(URL_HEAD + body + train_type + CONSUMERKEY)

    response = Net::HTTP.start(url.host, url.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(url.request_uri)
    end
    return JSON.parse(response.body)
  end

  #引数で渡した電車（山手線のみ）の列車時刻表をJSONで返す(平日ダイヤのみ)
  def self.get_train_timetable(direction)
    body = "odpt:TrainTimetable?"
    train_type = "odpt:railway=odpt.Railway:JR-East.Yamanote"
    day_type ="&odpt:calendar=odpt.Calendar:Weekday"

    if direction == 0
      direction_type = "&odpt:railDirection=odpt.RailDirection:InnerLoop"
    else
      direction_type = "&odpt:railDirection=odpt.RailDirection:OuterLoop"
    end

    url = URI.parse(URL_HEAD + body + train_type + day_type + direction_type + CONSUMERKEY)

    response = Net::HTTP.start(url.host, url.port) do |http|
      http.open_timeout = 100
      http.read_timeout = 100
      http.get(url.request_uri)
    end
    return JSON.parse(response.body)
  end

end
