class Driver < ActiveRecord::Base
  geocoded_by :full_address
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

  def full_address
    if current_city && current_state
      return "#{current_city}, #{current_state}"
    elsif current_city
      return "#{current_city}"
    else
      return "#{current_state}"
    end
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
