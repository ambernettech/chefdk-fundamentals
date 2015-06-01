module Powerpoint
  class OutlinePresentation < Presentation

    def slides
      data = presentation_xml
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
      data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst/p14:sldId")
    end

    def sections
      data = presentation_xml
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
      data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst").map do |section|
        Section.new(section)
      end
    end

    #
    # There is an implied default that the insertion point within the section is
    # after the first slide. Because, so far in the outline structured slide
    # decks that I have built they have allowed for the first slide to be an
    # agenda slide to give an idea where the content is located within the
    # entire world of the presentation
    #
    def slide_insertion_point_in_section(section_number)
      data = Nokogiri::XML(File.read("#{target_filepath}/ppt/presentation.xml"))
      data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"

      # find the first slide in the specified section of the presentation xm
      section_lists = data.xpath("//p:ext/p14:sectionLst/p14:section/p14:sldIdLst")


      section = section_lists[section_number - 1]
      slide_id_to_insert_after = section.xpath("p14:sldId").first["id"]

      # puts "    [??] Finding Insertion point in section #{section_number} #{slide_id_to_insert_after}"

      # then I need to convert that slide number into the relationship_id
      slide = data.xpath("//p:sldIdLst/p:sldId").find { |slide| slide["id"] == slide_id_to_insert_after }
      relative_id_to_insert_after = slide["r:id"]

      # puts "    [??] Inserting slides after slide with #{relative_id_to_insert_after}"

      # with that relationship id I need to convert that to a file name
      rels_data = Nokogiri::XML(File.read("#{target_filepath}/ppt/_rels/presentation.xml.rels"))
      relationship_to_insert_after = rels_data.xpath("//xmlns:Relationship[@Id='#{relative_id_to_insert_after}']")
      filepath_to_insert_after = relationship_to_insert_after.first["Target"]

      # puts "    [??] Inserting slides after slide with filepath #{filepath_to_insert_after}"

      # from that file name I need to take that file name slide number and add one
      file_number_to_insert_after = filepath_to_insert_after.match(/\d+/)[0].to_i

      slide_insertion_point = file_number_to_insert_after + 1

      puts "    [??] Inserting slides after #{slide_insertion_point}"
      slide_insertion_point
    end

  end
end