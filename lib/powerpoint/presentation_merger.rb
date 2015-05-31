module Powerpoint
  module PresentationMerger
    extend self

    def my_move(source,destination)
      `mv #{source} #{destination}`
      # puts "mv #{source} #{destination}"
    end

    def shift_slides(presentation,partial_path,extension,insertion_point,total_slide_count,shift)
      (insertion_point..total_slide_count).to_a.reverse.each do |mover|
        source_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover}.#{extension}"
        dest_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover + shift}.#{extension}"
        my_move(source_filepath,dest_filepath)
      end
    end

    def copy_slides(source_presentation,destination_presentation,partial_path,extension,insertion_point,start,finish)
      (start..finish).each do |num|
        source_filepath = "#{source_presentation.target_filepath}/#{partial_path}/slide#{num}.#{extension}"
        dest_filepath = "#{destination_presentation.target_filepath}/#{partial_path}/slide#{num + insertion_point - 1}.#{extension}"
        my_move(source_filepath,dest_filepath)
      end
    end

    def merge(outline_presentation,presentation,section_number)

      slides_to_insert_count = presentation.slides.count

      insertion_point = find_slide_insertion_point_in_section(outline_presentation,section_number)
      total_slide_count = outline_presentation.slides.count

      puts "[?] In outline presentation I am shifting slides by #{slides_to_insert_count} starting at #{insertion_point} to #{total_slide_count}"

      shift_slides(outline_presentation,"ppt/slides/_rels","xml.rels",insertion_point,total_slide_count,slides_to_insert_count)
      copy_slides(presentation,outline_presentation,"ppt/slides/_rels","xml.rels",insertion_point,1,slides_to_insert_count)

      # From the insert position, place the slides rels in there

      shift_slides(outline_presentation,"ppt/slides","xml",insertion_point,total_slide_count,slides_to_insert_count)
      copy_slides(presentation,outline_presentation,"ppt/slides","xml",insertion_point,1,slides_to_insert_count)

      # updated the [Content Types].xml
      #   - slide entry

      (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
        puts "[+] Adding [Content_Types].xml entry for slide #{num}"
        add_slide_to_content_type(outline_presentation,num)
      end

      # updated the ppt/_rels/presentation.xml.rels
      #   - slide entry

      # TODO: Instead of finding the highest relationship_id this file needs the slide
      #   relationships added and then for all the relationship_ids to be rebuilt

      # Find the highest relationship_id
      starting_relationship_id = fetch_highest_relationship_id(outline_presentation)

      puts "[?] Relationships Starting Count : #{starting_relationship_id}"

      (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
        puts "[+] Adding ppt/_rels/presentation.xml.rels entry for slide #{num}"
        add_slide_to_presentation_relationships(outline_presentation,num)
      end

      finishing_relationship_id = fetch_highest_relationship_id(outline_presentation)

      puts "[?] Relationships Finishing Count :#{finishing_relationship_id}"

      # updated the ppt/presentation.xml
      #   - slide id in the slide list that translates relationship_id
      #   - slide id in the extList
      ((starting_relationship_id + 1)..finishing_relationship_id).each do |num|
        puts "[+] Adding ppt/presentation.xml entry for slide rId#{num} into section #{section_number}"
        add_slide_to_presentation(outline_presentation,num,section_number)
      end

    end


    def find_slide_insertion_point_in_section(presentation,section_number)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/presentation.xml"))
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

      # find the first slide in the specified section of the presentation xm
      section_lists = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst")


      section = section_lists[section_number - 1]
      slide_id_to_insert_after = section.xpath("p14:sldId").first["id"]

      puts "    [??] Finding Insertion point in section #{section_number} #{slide_id_to_insert_after}"

      # then I need to convert that slide number into the relationship_id
      slide = data.xpath("//p:sldIdLst/p:sldId").find { |slide| slide["id"] == slide_id_to_insert_after }
      relative_id_to_insert_after = slide["r:id"]

      puts "    [??] Inserting slides after slide with #{relative_id_to_insert_after}"

      # with that relationship id I need to convert that to a file name
      rels_data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/_rels/presentation.xml.rels"))
      relationship_to_insert_after = rels_data.xpath("//xmlns:Relationship[@Id='#{relative_id_to_insert_after}']")
      filepath_to_insert_after = relationship_to_insert_after.first["Target"]

      puts "    [??] Inserting slides after slide with filepath #{filepath_to_insert_after}"

      # from that file name I need to take that file name slide number and add one
      file_number_to_insert_after = filepath_to_insert_after.match(/\d+/)[0].to_i

      slide_insertion_point = file_number_to_insert_after + 1

      puts "    [??] Inserting slides after slides after #{slide_insertion_point}"
      slide_insertion_point
    end

    def add_slide_to_content_type(presentation,num)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/[Content_Types].xml"))
      types_node = data.children.first

      slide = Nokogiri::XML::Node.new "Override", data
      slide["ContentType"] = "application/vnd.openxmlformats-officedocument.presentationml.slide+xml"
      slide["PartName"] = "/ppt/slides/slide#{num}.xml"
      # puts slide.to_s
      types_node.add_child(slide)

      File.write("#{presentation.target_filepath}/[Content_Types].xml",data.to_xml)
    end

    def add_slide_to_presentation_relationships(presentation,num)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/_rels/presentation.xml.rels"))
      relationships_node = data.children.first

      relationship = Nokogiri::XML::Node.new "Relationship", data
      relationship["Id"] = "rId#{fetch_highest_relationship_id(presentation) + 1}"
      relationship["Target"] = "slides/slide#{num}.xml"
      relationship["Type"] = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide"
      #puts relationship.to_s
      relationships_node.add_child(relationship)

      File.write("#{presentation.target_filepath}/ppt/_rels/presentation.xml.rels",data.to_xml)
    end

    def fetch_highest_relationship_id(presentation)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/_rels/presentation.xml.rels"))

      data.xpath("//xmlns:Relationship").map do |relationship|
        relationship["Id"].gsub("rId","").to_i
      end.compact.max
    end

    def fetch_highest_slide_id(presentation)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/presentation.xml"))
      slide_id_list = data.xpath("//p:sldIdLst")

      slide_id_list.children.map do |slide_id|
         slide_id["id"].to_i
      end.max
    end

    def add_slide_to_presentation(presentation,num,section_number)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/presentation.xml"))
      # Fix to make it so I can xpath to the section lists
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

      relationship_id = "rId#{num}"
      slide_id = fetch_highest_slide_id(presentation) + 1

      # Add a new entry to the Slide Id List
      slide_id_list = data.xpath("//p:sldIdLst").first

      slide_id_entry = Nokogiri::XML::Node.new "p:sldId", data
      slide_id_entry["id"] = slide_id
      slide_id_entry["r:id"] = relationship_id
      puts "[??] Inserting slide id:#{slide_id} #{relationship_id}"
      slide_id_list.xpath("p:sldId").last.add_next_sibling(slide_id_entry)

      # from the target section_number start there and have it grab a slide from the next section
      #   if there is a next section
      # That section needs to lose the slide
      # We continue to do that until we run out of sections
      section_slide_id_lists = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst")[(section_number - 1)..-1]

      section_slide_id_lists.each_with_index do |section,index|
        next_section = section_slide_id_lists[index + 1]
        next unless next_section

        next_section_slide = next_section.xpath("p14:sldId").first

        slides_in_current_section = section.xpath("p14:sldId")
        slides_in_current_section.last.add_next_sibling(next_section_slide)
      end


      slide_entry = Nokogiri::XML::Node.new "p14:sldId", data
      slide_entry["id"] = slide_id

      slide_entry.parent = section_slide_id_lists.last

      # Add a new entry to the last section and we allow another process to re-organize it
      # section_slide_id_list = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst")


      # section_slide_id_list.xpath("p14:sldId").last.add_next_sibling(slide_entry)
      # puts section_slide_id_list
      File.write("#{presentation.target_filepath}/ppt/presentation.xml",data.to_xml)
    end
  end
end