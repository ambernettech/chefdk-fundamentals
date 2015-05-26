#
# Rake tasks for building, managing, and packaging the ChefDK-Fundamentals
#

# This is provides quick-and-dirty support for the metadata file within this project
def name(value) ; value ? @name = value : @name ; end
def maintainer(value) ; value ? @maintainer = value : @maintainer ; end
def maintainer_email(value) ; value ? @maintainer_email = value : @maintainer_email ; end
def license(value) ; value ? @license = value : @license ; end
def description(value) ; value ? @description = value : @description ; end
def version(value = nil) ; value ? @version = value : @version ; end

instance_eval(File.read("metadata.rb"))

namespace :package do

  desc "Create a packge for ChefDK Fundamentals - Day 1"
  task :day1 do

    complete_presentation_filename = 'chefdk-introduction_to_chefdk.pptx'
    scene_numbers = (1..9).map {|num| "%02d" % num }
    guide_files = scene_numbers.map {|num| "scene_#{num}-GUIDE.md" }
    archive_filename = "ChefDK-Introduction_to_Chef-#{version}.zip"
    archive_command = "zip #{archive_filename} #{complete_presentation_filename} #{guide_files.join(' ')}"

    puts """
********************************************************************************

  YOU need to create the day 1 presentation from the following chapters:

  * Open 'day_one.pptx'
  * Insert 'scene_#{scene_numbers.first}-SLIDES.pptx' into through 'scene_#{scene_numbers.last}-SLIDES.pptx'
    into the appropriate sections in the template
  * Save the file as '#{complete_presentation_filename}'

  PRESS <ENTER> when READY
  PRESS <ESC> to QUIT

********************************************************************************
"""

    wait = STDIN.gets

    puts """
********************************************************************************

  Zipping up Day 1

  * Archiving '#{complete_presentation_filename}'
"""

  scene_numbers.each do |num|
    puts """    * Archiving 'scene-#{num}-GUIDE.md'"""
  end

    puts """
********************************************************************************
  """

    `#{archive_command}`

  end

end
