# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TemplateRails3::Application.initialize!

Paperclip.options[:command_path] = "/usr/local/ImageMagick-6.6.1/bin"