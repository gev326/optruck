class Driver < ActiveRecord::Base
  geocoded_by :current_location
  after_validation :geocode

  belongs_to :user

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def current_location
    current_city_exists = current_city != nil && current_city.length != 0
    current_state_exists = current_state != nil && current_state.length != 0
    if current_city_exists && current_state_exists
      return "#{current_city}, #{current_state}"
    elsif current_city_exists
      return "#{current_city}"
    elsif current_state_exists
      return "#{current_state}"
    end
    ""
  end

  def desired_location
    desired_city_exists = desired_city != nil && desired_city.length != 0
    desired_state_exists = desired_state != nil && desired_state.length != 0
    if desired_city_exists && desired_state_exists
      return "#{desired_city}, #{desired_state}"
    elsif desired_city_exists
      return "#{desired_city}"
    elsif desired_state_exists
      return "#{desired_state}"
    end
    ""
  end

  def driver_info
    "#{desired_state} #{desired_zip} #{driver_phone}"
  end

  def gmaps4rails_marker_picture
   {
    "picture" => "/assets/images/map2s.png",          # string,  mandatory
     "width" =>  "32",          # integer, mandatory
     "height" => "32",          # integer, mandatory
                       # See doc here: http://google-maps-utility-library-v3.googlecode.com/svn/trunk/richmarker/docs/reference.html
   }
  end

  def self.search(search)
   where("first_name LIKE ? OR desired_state LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.desired_city(desired)
    desired = all
    desired = desired.where("desired_city LIKE ?", "%#{desired}%")
    return desired
  end

end
