class Driver < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  :acts_as_gmappable

# reverse_geocoded_by :latitude, :longitude
# after_validation :reverse_geocode  # auto-fetch address




belongs_to :user




ransacker :full_name do |parent|
  Arel::Nodes::InfixOperation.new('||',
    Arel::Nodes::InfixOperation.new('||',
      parent.table[:first_name], Arel::Nodes.build_quoted(' ')
    ),
    parent.table[:last_name]
  )
end

# def gmaps4rails_address
#   "#{driver.address}"
# end


  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address}, #{state}"
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
