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

  desc "Create a package for ChefDK Fundamentals - Day 1"
  task :day1 do

    complete_presentation_filename = 'chefdk-introduction_to_chefdk.pptx'
    scene_numbers = (1..9).map {|num| "%02d" % num }
    guide_files = scene_numbers.map {|num| "scene_#{num}-GUIDE.md" }
    archive_filename = "ChefDK-Introduction_to_Chef-#{version}.zip"
    archive_command = "zip #{archive_filename} #{complete_presentation_filename} #{guide_files.join(' ')}"

    puts """
********************************************************************************

  Creating the Day 1 presentation from the following chapters:

  * Open 'day_one.pptx'
  * Insert 'scene_#{scene_numbers.first}-SLIDES.pptx' into through 'scene_#{scene_numbers.last}-SLIDES.pptx'
    into the appropriate sections in the template
  * Save the file as '#{complete_presentation_filename}'

********************************************************************************
"""

    Rake::Task["ppt:merge"].invoke

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

$LOAD_PATH.unshift("./lib")
require 'powerpoint'

namespace :ppt do

  task :clean do
    `rm -rf day_one`
    (1..9).map {|num| "scene_%02d-SLIDES" % num }.each {|path| `rm -rf #{path}` }
    `rm -rf day_one-complete.pptx`
  end

  desc "Explode Day One"
  task :explode => :clean do
    Powerpoint::Presentation.new("day_one.pptx")
    (1..9).map {|num| "scene_%02d-SLIDES.pptx" % num }.each do |presentation_file|
      # This will decompress them
      Powerpoint::Presentation.new(presentation_file)
    end
  end

  desc "Merge the sections into the outline presentation"
  task :merge => :clean do
    outline = Powerpoint::OutlinePresentation.new("day_one.pptx")

    (1..9).map {|num| "scene_%02d-SLIDES.pptx" % num }.each_with_index do |presentation_file,index|
      presentation = Powerpoint::Presentation.new(presentation_file)
      section = index + 1
      Powerpoint::PresentationMerger.merge(outline,presentation,section)
    end

    Powerpoint.compress("day_one","chefdk-introduction_to_chefdk.pptx")

    # Clean Up
    (1..9).map {|num| "scene_%02d-SLIDES" % num }.each {|path| `rm -rf #{path}` }
    `rm -rf day_one`

  end


end

