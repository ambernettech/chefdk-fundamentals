module Powerpoint
  class FileSystem

    class Presentation
      def initialize(presentation)
        @presentation = presentation
      end

      attr_reader :presentation

      def relative_filepath
        "ppt/presentation.xml"
      end

      def filepath
        "#{presentation.target_filepath}/#{relative_filepath}"
      end

      def data
        @data ||= begin
          _data = Nokogiri::XML(File.read(filepath))
          # Fix to make it so I can xpath to the section lists
          _data.root.add_namespace "p14", "http://schemas.microsoft.com/office/powerpoint/2010/main"
          _data
        end
      end

      def add_slide(slide_number,section_number)
        relationship_id = "rId#{slide_number}"
        slide_id = presentation.highest_slide_id + 1

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
      end

      def save
        puts "[S]aving the Presentation"
        File.write(filepath,data.to_xml)
        @data = nil
      end

    end

  end
end