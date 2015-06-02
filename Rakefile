#
# Rake tasks for building, managing, and packaging the ChefDK-Fundamentals
#


$LOAD_PATH.unshift("./lib")
require 'powerpoint'

# This is provides quick-and-dirty support for the metadata file within this project
def name(value) ; value ? @name = value : @name ; end
def maintainer(value) ; value ? @maintainer = value : @maintainer ; end
def maintainer_email(value) ; value ? @maintainer_email = value : @maintainer_email ; end
def license(value) ; value ? @license = value : @license ; end
def description(value) ; value ? @description = value : @description ; end
def version(value = nil) ; value ? @version = value : @version ; end

instance_eval(File.read("metadata.rb"))

def display_proposed_merge_work(title,outline_presentation,scene_numbers,complete_presentation_filename)
  puts """
********************************************************************************

  Creating #{title}:

  * Openining #{outline_presentation}
  * Insert 'scene_#{scene_numbers.first}-SLIDES.pptx' into through 'scene_#{scene_numbers.last}-SLIDES.pptx'
    into the appropriate sections in the template
  * Save the file as '#{complete_presentation_filename}'

********************************************************************************
"""

end

def display_proposed_archive_work(title,scene_numbers,complete_presentation_filename)
  puts """
********************************************************************************

  Archiving #{title}

  * Archiving '#{complete_presentation_filename}'
"""
  scene_numbers.each { |num| puts """    * Archiving 'scene-#{num}-GUIDE.md'""" }

  puts """
********************************************************************************
  """
end

namespace :package do

  desc "Create a package for ChefDK Fundamentals - Day 1"
  task :day1 do
    title = "ChefDK Fundamentals - Introduction to Chef"
    outline_presentation = "day_one.pptx"
    complete_presentation_filename = 'chefdk-introduction_to_chefdk.pptx'
    scene_numbers = (1..9).map {|num| "%02d" % num }
    guide_files = scene_numbers.map {|num| "scene_#{num}-GUIDE.md" }
    archive_filename = "ChefDK-Introduction_to_Chef-#{version}.zip"
    archive_command = "zip #{archive_filename} #{complete_presentation_filename} #{guide_files.join(' ')}"

    display_proposed_merge_work(title,outline_presentation,scene_numbers,complete_presentation_filename)

    Rake::Task["ppt:day1:merge"].invoke

    display_proposed_archive_work(title,scene_numbers,complete_presentation_filename)

    `#{archive_command}`
  end

  desc "Create a package for ChefDK Fundamentals - Day 2"
  task :day2 do
    title = "ChefDK Fundamentals - Introduction to Chef Server"
    outline_presentation = "day_two.pptx"
    complete_presentation_filename = 'chefdk-introduction_to_chef_server.pptx'
    scene_numbers = ([1] + (10..15).to_a).map {|num| "%02d" % num }
    guide_files = scene_numbers.map {|num| "scene_#{num}-GUIDE.md" }
    archive_filename = "ChefDK-Introduction_to_Chef_Server-#{version}.zip"
    archive_command = "zip #{archive_filename} #{complete_presentation_filename} #{guide_files.join(' ')}"

    display_proposed_merge_work(title,outline_presentation,scene_numbers,complete_presentation_filename)

    Rake::Task["ppt:day2:merge"].invoke

    display_proposed_archive_work(title,scene_numbers,complete_presentation_filename)

    `#{archive_command}`
  end

end


namespace :ppt do
  namespace :day1 do

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
        outline.merge(presentation).into(section: section)
      end

      Powerpoint.compress("day_one","chefdk-introduction_to_chefdk.pptx")

      `rm -rf day_one`
      (1..9).map {|num| "scene_%02d-SLIDES" % num }.each {|path| `rm -rf #{path}` }
    end

  end

  namespace :day2 do

    task :clean do
      `rm -rf day_two`
      `rm chefdk-introduction_to_chef_server.pptx`
      ([1] + (10..15).to_a).map {|num| "scene_%02d-SLIDES" % num }.each {|path| `rm -rf #{path}` }
    end

    task :explode => :clean do
      Powerpoint::Presentation.new("day_two.pptx")
      ([1] + (10..15).to_a).map {|num| "scene_%02d-SLIDES.pptx" % num }.each do |presentation_file|
        # This will decompress them
        Powerpoint::Presentation.new(presentation_file)
      end
    end

    desc "Merge the sections into the outline presentation"
    task :merge => :clean do
      outline = Powerpoint::OutlinePresentation.new("day_two.pptx")

      ([1] + (10..15).to_a).map {|num| "scene_%02d-SLIDES.pptx" % num }.each_with_index do |presentation_file,index|
        presentation = Powerpoint::Presentation.new(presentation_file)
        section = index + 1
        outline.merge(presentation).into(section: section)
      end

      Powerpoint.compress("day_two","chefdk-introduction_to_chef_server.pptx")

      `rm -rf day_two`
      ([1] + (10..15).to_a).map {|num| "scene_%02d-SLIDES" % num }.each {|path| `rm -rf #{path}` }
    end

  end

end

