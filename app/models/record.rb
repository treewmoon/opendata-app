require "jre_api.rb"

class Record < ApplicationRecord
  belongs_to :user
  NUM_YAMANOTE_STATIONS = 29


  #現在時刻の取得
  def self.get_now_time
    hour = Time.now.hour.to_s
    min  = Time.now.min.to_s
    if min.length == 1
      min = "0" + min
    end
    now = hour + ":" + min
    return now
  end


  #
  #引数:スタートの駅id,ゴールの駅id,内回り(0)or外回り(1)(s_i,g_i,d,limit)
  def self.search_trains(s_i,g_i,d)

    trains = []
    json = Jre_api.get_location
    if d == 0
      direction ="odpt.RailDirection:InnerLoop"
      main_json = Jre_api.get_train_timetable(0)
    else
      direction ="odpt.RailDirection:OuterLoop"
      main_json = Jre_api.get_train_timetable(1)
    end

    for j in json do
      if j["odpt:railDirection"] == direction
        train = {}
        train["number"] = j["odpt:trainNumber"]
        train["arrivalTime"] = Record.get_arrivalTime(train["number"],s_i,main_json)
        next if train["arrivalTime"] == nil
        trains << train
      end
    end

    now_time = Record.get_now_time.gsub(/:/, "").to_i
    opponents = []
    for t in trains do
      opponent = {}
      arrival_start_time = t["arrivalTime"].gsub(/:/, "").to_i
      if now_time >= arrival_start_time
        opponent["number"] = Record.update_train_number(t["number"],main_json)
        next if opponent["number"] == nil
      else
        opponent["number"] = t["number"]
      end
      opponent["start_time"] = Record.get_arrivalTime(opponent["number"],s_i,main_json)
      opponent["goal_time"] = Record.get_arrivalTime(opponent["number"],g_i,main_json)
      opponent["time_for_sort"] = opponent["start_time"].gsub(/:/, "").to_i
      opponents << opponent
    end

    # opponents.sort_by! { |a| a[:time_for_sort] }
    # new_opponents = opponents.sort!{ |a, b| a[:time_for_sort] <=> b[:time_for_sort] }

    return opponents
  end




  #ある電車がある駅に到着する時間を返す
  #引数1:電車の列番
  #引数2:駅の駅id
  #引数3:参照する時刻表(jsonファイル)
  def self.get_arrivalTime(train_number,station_id,jsons)
    for j in jsons do
      if j["odpt:trainNumber"] == train_number
        json = j
        break
      end
    end

    times = json["odpt:trainTimetableObject"]
    for t in times do
      #謎のエラーの対策
      next if t["odpt:departureStation"] == nil

      station = t["odpt:departureStation"].gsub(/odpt.Station:JR-East.Yamanote./, "")
      if station == Station.find(station_id).name_en
        arrivalTime = t["odpt:departureTime"]
        break
      end
    end

    return arrivalTime
  end


  #今現在走っている電車の列番を次の電車の列番に更新
  def self.update_train_number(old_train_number,jsons)
    for j in jsons do
      if j["odpt:trainNumber"] == old_train_number
        json = j
        break
      end
    end
    #謎エラーの対策
    if json["odpt:nextTrainTimetable"] != nil
      new_train_number = json["odpt:nextTrainTimetable"][0]
      new_train_number = new_train_number.gsub(/odpt.TrainTimetable:JR-East.Yamanote./, "")
      new_train_number = new_train_number.gsub(/.Weekday/, "")
    end
    return new_train_number
  end


  def self.get_stations_inner(start_station,limit)
    stations = []
    n = 0
    station = start_station
    while n < limit do
      station += 1
      if station > NUM_YAMANOTE_STATIONS
        station = 1
      end
      stations << station
      n += 1
    end
    return stations
  end


  def self.get_stations_outer(start_station,limit)
    stations = []
    n = 0
    station = start_station
    while n < limit do
      station -= 1
      if station == 0
        station = NUM_YAMANOTE_STATIONS
      end
      stations << station
      n += 1
    end
    return stations
  end


end
