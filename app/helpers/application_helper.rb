module ApplicationHelper
  def humanize_boolean(boolean)
    I18n.t((!!boolean).to_s)
  end

  def us_states
    CS.states(:us)
  end

  def self.cities(state)
    state = state.downcase.to_sym
    CS.cities(state, :us)
  end

  def destination_zones
    {
      :Z0 => ['CT','ME','MA','NH','NJ','RI','VT'],

      :Z1 => ['DE','NY','PA'],

      :Z2 => ['DC','MD','NC','SC','VA','WV'],

      :Z3 => ['AL','FL','GA','MS','TN'],

      :Z4 => ['IN','KY','MI','OH'],

      :Z5 => ['IA','MN','MT','ND','SD','WI'],

      :Z6 => ['IL','KS','MO','NE'],

      :Z7 => ['AR','LA','OK','TX'],

      :Z8 => ['AZ','CO','ID','NV','NM','UT','WY'],

      :Z9 => ['CA', 'OR', 'WA']
    }
  end

 def get_destination_zone state_abbrv
    result = 'Unknown Zone'
    destination_zones.each_pair do |zone, states|
      result = zone if states.include? state_abbrv
    end
    result
  end


  def current_zones
    {
      :Z0 => ['CT','ME','MA','NH','NJ','RI','VT'],

      :Z1 => ['DE','NY','PA'],

      :Z2 => ['DC','MD','NC','SC','VA','WV'],

      :Z3 => ['AL','FL','GA','MS','TN'],

      :Z4 => ['IN','KY','MI','OH'],

      :Z5 => ['IA','MN','MT','ND','SD','WI'],

      :Z6 => ['IL','KS','MO','NE'],

      :Z7 => ['AR','LA','OK','TX'],

      :Z8 => ['AZ','CO','ID','NV','NM','UT','WY'],

      :Z9 => ['CA', 'OR', 'WA']
    }
  end

  def get_current_zone state_abbrv
    result = 'Unknown Zone'
      current_zones.each_pair do |zone, states|
      result = zone if states.include? state_abbrv
    end
    result
  end

  def state_map
    states = {
      "Alabama" => "AL",
      "Alaska" => "AK",
      "Arizona" => "AZ",
      "Arkansas" => "AR",
      "California" => "CA",
      "Colorado" => "CO",
      "Connecticut" => "CT",
      "Delaware" => "DE",
      "Florida" => "FL",
      "Georgia" => "GA",
      "Hawaii" => "HI",
      "Idaho" => "ID",
      "Illinois" => "IL",
      "Indiana" => "IN",
      "Iowa" => "IA",
      "Kansas" => "KS",
      "Kentucky" => "KY",
      "Louisiana" => "LA",
      "Maine" => "ME",
      "Maryland" => "MD",
      "Massachusetts" => "MA",
      "Michigan" => "MI",
      "Minnesota" => "MN",
      "Mississippi" => "MS",
      "Missouri" => "MO",
      "Montana" => "MT",
      "Nebraska" => "NE",
      "Nevada" => "NV",
      "New Hampshire" => "NH",
      "New Jersey" => "NJ",
      "New Mexico" => "NM",
      "New York" => "NY",
      "North Carolina" => "NC",
      "North Dakota" => "ND",
      "Ohio" => "OH",
      "Oklahoma" => "OK",
      "Oregon" => "OR",
      "Pennsylvania" => "PA",
      "Rhode Island" => "RI",
      "South Carolina" => "SC",
      "South Dakota" => "SD",
      "Tennessee" => "TN",
      "Texas" => "TX",
      "Utah" => "UT",
      "Vermont" => "VT",
      "Virginia" => "VA",
      "Washington" => "WA",
      "West Virginia" => "WV",
      "Wisconsin" => "WI",
      "Wyoming" => "WY"
    }
  end

  def get_state_abbrev state
    state_map[state]
  end
end
