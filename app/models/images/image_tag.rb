class Images::ImageTag < ActiveRecord::Base
  belongs_to :image,:class_name => "::Image"
  belongs_to :tag,:class_name => "::Images::Tag"
end
