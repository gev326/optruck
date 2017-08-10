class Driver < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode
  :acts_as_gmappable

belongs_to :user

  def full_name
    "#{first_name} #{last_name}"
  end

  def driver_info
    "#{desired_state} #{desired_zip} #{driver_phone}"
  end

def gmaps4rails_marker_picture
  {
   "picture" => "/assets/images/#{map2s}.png",
   "width" => 20,
   "height" => 20,
   "marker_anchor" => [ 5, 10],
   "shadow_picture" => "/images/morgan.png" ,
   "shadow_width" => "110",
   "shadow_height" => "110",
   "shadow_anchor" => [5, 10],
  }
end


end
