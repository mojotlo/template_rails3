# == Schema Information
# Schema version: 20110719164953
#
# Table name: profiles
#
#  id                  :integer         not null, primary key
#  about               :text
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#

require 'digest'
class Profile < ActiveRecord::Base

attr_accessible  :about, :avatar, :avatar_file_name, :avatar_file_size, :avatar_updated_at, :avatar_content_type

belongs_to :user 


has_attached_file :avatar,
:url => "/:class/:attachment/:id/:style_:basename.:extension",
:default_url => "/:class/:attachment/missing_:style.png",
:styles => {
   :thumb  => "100x100#",
   :small  => "150x150>",
   :large  => "450x450>"
}

end
