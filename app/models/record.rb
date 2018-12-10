require "jre_api.rb"

class Record < ApplicationRecord
  belongs_to :user
  NUM_YAMANOTE_STATIONS = 29

  def self.print(s)
    return Jre_api.get_train_timetable(s)
  end


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
  def self.search_trains(s_i,g_i,d,limit)
    trains = []
    json = Jre_api.get_location

    if d == 0
      direction ="odpt.RailDirection:InnerLoop"
    else
      direction ="odpt.RailDirection:OuterLoop"
    end

    for j in json do
      if j["odpt:railDirection"] == direction
        train = {}
        train["number"] = j["odpt:trainNumber"]
        # location = j["odpt:fromStation"].gsub(/odpt.Station:JR-East.Yamanote./, "")
        # train["location"] = Station.find_by(name_en: location).id
        train["arrivalTime"] = Record.get_arrivalTime(train["number"],s_i)
        # train["delay"] = j["odpt:delay"]/60

        #時刻表に存在しない列番がロケーション情報に存在する時
        if train["arrivalTime"] != 0
          trains << train
        end
        # trains << train
      end
    end

    now_time = Record.get_now_time.gsub(/:/, "").to_i

    opponents = []
    for t in trains do
      opponent = {}

      arrival_start_time = Record.get_arrivalTime(t["number"],s_i).gsub(/:/, "").to_i
      # arrival_start_time = arrival_start_time.gsub(/:/, "").to_i

      if now_time > arrival_start_time
        opponent["number"] = Record.update_train_number(t["number"])
      else
        opponent["number"] = t["number"]
      end
      opponent["start_time"] = Record.get_arrivalTime(opponent["number"],s_i)
      opponent["goal_time"] = Record.get_arrivalTime(opponent["number"],g_i)
      opponents << opponent
    end
    return opponents
  end


  #引数で与えた電車が引数で与えた駅に到着する時間を返す
  def self.get_arrivalTime(train_number,station_id)
    json = Jre_api.get_train_timetable(train_number)

    #時刻表に存在しない列番のときは0を返す
    # if json == []
    #   binding.pry
    # end
    return 0 if json == []

    times = json[0]["odpt:trainTimetableObject"]
    for t in times do
      station = t["odpt:departureStation"].gsub(/odpt.Station:JR-East.Yamanote./, "")
      if station == Station.find(station_id).name_en
        arrivalTime = t["odpt:departureTime"]
        break
      end
    end
    return arrivalTime
  end


  #今現在走っている電車の列番を次の電車の列番に更新
  def self.update_train_number(old_train_number)
    json = Jre_api.get_train_timetable(old_train_number)
    new_train_number = json[0]["odpt:nextTrainTimetable"][0]
    new_train_number = new_train_number.gsub(/odpt.TrainTimetable:JR-East.Yamanote./, "")
    new_train_number = new_train_number.gsub(/.Weekday/, "")
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
