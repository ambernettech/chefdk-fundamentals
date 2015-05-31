module Powerpoint
  module PresentationMerger
    extend self

    def my_move(source,destination)
      `mv #{source} #{destination}`
      puts "mv #{source} #{destination}"
    end

    def shift_files(presentation,partial_path,insertion_point,total_slide_count,shift)
      (insertion_point..total_slide_count).to_a.reverse.each do |mover|
        source_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover}.xml.rels"
        dest_filepath = "#{presentation.target_filepath}/#{partial_path}/slide#{mover + shift}.xml.rels"
        my_move(source_filepath,dest_filepath)
      end
    end

    def copy_files(source_presentation,destination_presentation,partial_path,insertion_point,start,finish)
      (start..finish).each do |num|
        source_filepath = "#{source_presentation.target_filepath}/#{partial_path}/slide#{num}.xml.rels"
        dest_filepath = "#{destination_presentation.target_filepath}/#{partial_path}/slide#{num + insertion_point - 1}.xml.rels"
        my_move(source_filepath,dest_filepath)
      end
    end

    def merge(outline_presentation,presentation,section_number)

      slides_to_insert_count = presentation.slides.count
      insertion_section = section_number
      insertion_point = section_number * 2
      total_slide_count = outline_presentation.slides.count

      # outline_presentation.insert_slides(presentation.slides,)

      shift_files(outline_presentation,"ppt/slides/_rels",insertion_point,total_slide_count,slides_to_insert_count)
      copy_files(presentation,outline_presentation,"ppt/slides/_rels",insertion_point,1,slides_to_insert_count)

      # From the insert position, place the slides rels in there

      shift_files(outline_presentation,"ppt/slides",insertion_point,total_slide_count,slides_to_insert_count)
      copy_files(presentation,outline_presentation,"ppt/slides",insertion_point,1,slides_to_insert_count)

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

      (total_slide_count + 1 .. total_slide_count + slides_to_insert_count).each do |num|
        puts "[+] Adding ppt/_rels/presentation.xml.rels entry for slide #{num}"
        add_slide_to_presentation_relationships(outline_presentation,num)
      end

      finishing_relationship_id = fetch_highest_relationship_id(outline_presentation)

      # updated the ppt/presentation.xml
      #   - slide id in the slide list that translates relationship_id
      #   - slide id in the extList
      ((starting_relationship_id + 1)..finishing_relationship_id).each do |num|
        puts "[+] Adding ppt/presentation.xml entry for slide rId#{num}"
        add_slide_to_presentation(outline_presentation,num)
      end

      # TODO: The re-organizing will need to update the relationship ids
      #  notesMasterId
      #  handoutMasterId

      # FIX: an additional slide is getting added (off by one)
      #   FIND that before the massive re-ordering

      reorganize_slides_in_presentation(outline_presentation,insertion_section,slides_to_insert_count)

    end


    def add_slide_to_content_type(presentation,num)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/[Content_Types].xml"))
      types_node = data.children.first

      slide = Nokogiri::XML::Node.new "Override", data
      slide["ContentType"] = "application/vnd.openxmlformats-officedocument.presentationml.slide+xml"
      slide["PartName"] = "/ppt/slides/slide#{num}.xml"
      # puts slide.to_s
      types_node.add_child(slide)

      #File.write("#{presentation.target_filepath}/[Content_Types].xml",data.to_xml)
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
      relationships_node = data.children.first

      relationships_node.children.map do |relationship|
        next if relationship.type.to_i == Nokogiri::XML::Node::TEXT_NODE
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

    #
    # In the previous step we place all the slides into xml file in the last
    # section. We
    def reorganize_slides_in_presentation(presentation,section,slide_count)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/presentation.xml"))
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

      File.write("#{presentation.target_filepath}/ppt/presentation.xml",data.to_xml)
    end

    def add_slide_to_presentation(presentation,num)
      data = Nokogiri::XML(File.read("#{presentation.target_filepath}/ppt/presentation.xml"))
      # Fix to make it so I can xpath to the section lists
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

      relationship_id = "rId#{num}"
      slide_id = fetch_highest_slide_id(presentation) + 1
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
      File.write("#{presentation.target_filepath}/ppt/presentation.xml",data.to_xml)
    end
  end
end