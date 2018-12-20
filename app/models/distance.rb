class Distance < ApplicationRecord
  NUM_YAMANOTE_STATIONS = 29

  #2駅間の距離を返す(direction:0=inner,1=outer)
  def self.get_distance(s_id,g_id,direction)
    potision = s_id
    dis = 0
    count = 0
    while potision != g_id do
      #inner
      if direction == 0
        dis += Distance.find_by(s_id: potision).meter
        if potision == NUM_YAMANOTE_STATIONS
          potision = 1
        else
          potision += 1
        end
      #outer
      else
        dis += Distance.find_by(g_id: potision).meter
        if potision == 1
          potision = NUM_YAMANOTE_STATIONS
        else
          potision -= 1
        end
      end
      #念の為
      count += 1
      if count > 50
        dis = 0
        break
      end
    end
    return dis
  end

end


