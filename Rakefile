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

# Find the insertion point
# Move all the existing slides up X (the number of slides to insert)
# Add entries for X number of slides that have been added to [Content Types].xml
# Read the ppt/_rels/presentation.xml.rels and find the highest relative id
# Generate relative ids at the highest + 1 for X slides
# Add entries for X number of slides into ppt/_rels/presentation.xml.rels
# Add entries for X number of slides into ppt/presentation.xml slide id table
# Add entries for X slides into ppt/presentation.xml section table
# 

# copy the slide xml
# copy the slide rels xml

# updated the [Content Types].xml
#   - slide entry
# updated the ppt/_rels/presentation.xml.rels
#   - slide entry
# updated the ppt/presentation.xml
#   - slide id in the slide list that translates relationship_id
#   - slide id in the extList

require 'powerpoint'
require 'pry'
require 'nokogiri'

namespace :ppt do
  
  task :clean do
    `rm -rf day_one`
    `rm -rf scene_01`
  end

  desc "Explode Day One"  
  task :explode => :clean do
    Powerpoint.decompress_pptx("day_one.pptx","day_one")
    Powerpoint.decompress_pptx("scene_01-SLIDES.pptx","scene_01")
  end
  

  desc "Re-Collect Day One"
  task :collect do
    `rm -rf day_one-frankenstein`
    `rm -rf day_one-frankenstein.pptx`
    Powerpoint.compress_pptx("day_one","day_one-frankenstein.pptx")
    `open day_one-frankenstein.pptx`
    Powerpoint.decompress_pptx("day_one-frankenstein.pptx","day_one-frankenstein")
  end


  task :open do
    `rm -rf day_one-frankenstein`
    Powerpoint.decompress_pptx("day_one-frankenstein.pptx","day_one-frankenstein")
    `rm -rf day_one-repaired`
    Powerpoint.decompress_pptx("day_one-repaired.pptx","day_one-repaired")
  end  

  def my_move(source,destination)
    `mv #{source} #{destination}`
    puts "mv #{source} #{destination}"
  end

  def add_slide_to_content_type(num)
    data = Nokogiri::XML(File.read("day_one/[Content_Types].xml"))
    types_node = data.children.first

    slide = Nokogiri::XML::Node.new "Override", data
    slide["ContentType"] = "application/vnd.openxmlformats-officedocument.presentationml.slide+xml"
    slide["PartName"] = "/ppt/slides/slide#{num}.xml"
    # puts slide.to_s
    types_node.add_child(slide)
    
    File.write("day_one/[Content_Types].xml",data.to_xml)
  end

  def add_slide_to_presentation_relationships(num)
    data = Nokogiri::XML(File.read("day_one/ppt/_rels/presentation.xml.rels"))
    relationships_node = data.children.first

    relationship = Nokogiri::XML::Node.new "Relationship", data
    relationship["Id"] = "rId#{fetch_highest_relationship_id + 1}"
    relationship["Target"] = "slides/slide#{num}.xml"
    relationship["Type"] = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide"
    #puts relationship.to_s
    relationships_node.add_child(relationship)

    File.write("day_one/ppt/_rels/presentation.xml.rels",data.to_xml)
  end

  def fetch_highest_relationship_id
    data = Nokogiri::XML(File.read("day_one/ppt/_rels/presentation.xml.rels"))
    relationships_node = data.children.first

    relationships_node.children.map do |relationship|
      next if relationship.type.to_i == Nokogiri::XML::Node::TEXT_NODE
      relationship["Id"].gsub("rId","").to_i
    end.compact.max
  end

  def fetch_highest_slide_id
    data = Nokogiri::XML(File.read("day_one/ppt/presentation.xml"))
    slide_id_list = data.xpath("//p:sldIdLst")

    slide_id_list.children.map do |slide_id|
       slide_id["id"].to_i
    end.max    
  end

  #
  # In the previous step we place all the slides into xml file in the last 
  # section. We 
  def reorganize_slides_in_presentation(section,slide_count)
    data = Nokogiri::XML(File.read("day_one/ppt/presentation.xml"))
    # Fix to make it so I can xpath to the section lists
    data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

    slides = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst/p14:sldId")

    section_lists = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst")

    section_lists.each_with_index do |section_list,index|
      starting_index = (index * 2) + ((index + 1) > section ? slide_count : 0)
      finishing_index = starting_index + ((index + 1) == section ? slide_count + 1 : 1)

      puts "[++] Section #{index + 1} to have slides #{starting_index}..#{finishing_index}"
      puts "[??] #{slides[starting_index]}"
      puts "[??] #{slides[finishing_index]}"
      section_list.children = slides[starting_index..finishing_index]
    end

    File.write("day_one/ppt/presentation.xml",data.to_xml)
  end

  def add_slide_to_presentation(num)
    data = Nokogiri::XML(File.read("day_one/ppt/presentation.xml"))
    # Fix to make it so I can xpath to the section lists
    data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

    relationship_id = "rId#{num}"    
    slide_id = fetch_highest_slide_id + 1
    section_number = 1

    # Add a new entry to the Slide Id List
    slide_id_list = data.xpath("//p:sldIdLst").first

    slide_id_entry = Nokogiri::XML::Node.new "p:sldId", data
    slide_id_entry["id"] = slide_id
    slide_id_entry["r:id"] = relationship_id
    puts "[??] Inserting slide id:#{slide_id} r:id:#{relationship_id}"
    slide_id_list.xpath("p:sldId").last.add_next_sibling(slide_id_entry)

    # Add a new entry to the appropriate section (section_number)
    section_slide_id_list = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst").last
     
    slide_entry = Nokogiri::XML::Node.new "p14:sldId", data
    slide_entry["id"] = slide_id

    section_slide_id_list.xpath("p14:sldId").last.add_next_sibling(slide_entry)
    # puts section_slide_id_list
    File.write("day_one/ppt/presentation.xml",data.to_xml)
  end

  desc "Copy over one slide into the new presentation"
  task :copy => :explode do
    slides_to_insert_count = Dir["scene_01/ppt/slides/*.xml"].count
    insertion_section = 1
    insertion_point = 2
    total_slide_count = Dir["day_one/ppt/slides/*.xml"].count
    
    (insertion_point..total_slide_count).to_a.reverse.each do |mover|
      source_filepath = "day_one/ppt/slides/_rels/slide#{mover}.xml.rels"
      dest_filepath = "day_one/ppt/slides/_rels/slide#{mover + slides_to_insert_count}.xml.rels"
      my_move(source_filepath,dest_filepath)
    end

    # From the insert position, place the slides rels in there
    (1..slides_to_insert_count).each do |num|
      source_filepath = "scene_01/ppt/slides/_rels/slide#{num}.xml.rels"
      dest_filepath = "day_one/ppt/slides/_rels/slide#{num + insertion_point - 1}.xml.rels"
      my_move(source_filepath,dest_filepath)
    end
    
    (insertion_point..total_slide_count).to_a.reverse.each do |mover|
      source_filepath = "day_one/ppt/slides/slide#{mover}.xml"
      dest_filepath = "day_one/ppt/slides/slide#{mover + slides_to_insert_count}.xml"
      my_move(source_filepath,dest_filepath)
    end

    # From the insert position, place the slides in there
    (1..slides_to_insert_count).each do |num|
      source_filepath = "scene_01/ppt/slides/slide#{num}.xml"
      dest_filepath = "day_one/ppt/slides/slide#{num + insertion_point - 1}.xml"
      my_move(source_filepath,dest_filepath)
    end

    # updated the [Content Types].xml
    #   - slide entry

    (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
      puts "[+] Adding [Content_Types].xml entry for slide #{num}"
      add_slide_to_content_type(num)
    end

    # updated the ppt/_rels/presentation.xml.rels
    #   - slide entry

    # TODO: Instead of finding the highest relationship_id this file needs the slide
    #   relationships added and then for all the relationship_ids to be rebuilt
    
    # Find the highest relationship_id
    starting_relationship_id = fetch_highest_relationship_id

    (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
      puts "[+] Adding ppt/_rels/presentation.xml.rels entry for slide #{num}"
      add_slide_to_presentation_relationships(num)
    end

    finishing_relationship_id = fetch_highest_relationship_id
    
    # updated the ppt/presentation.xml
    #   - slide id in the slide list that translates relationship_id
    #   - slide id in the extList
    ((starting_relationship_id + 1)..finishing_relationship_id).each do |num|
      puts "[+] Adding ppt/presentation.xml entry for slide rId#{num}"
      add_slide_to_presentation(num)
    end

    # TODO: The re-organizing will need to update the relationship ids
    #  notesMasterId
    #  handoutMasterId
    
    # FIX: an additional slide is getting added (off by one)
    #   FIND that before the massive re-ordering

    reorganize_slides_in_presentation(insertion_section,slides_to_insert_count)


  end


end

