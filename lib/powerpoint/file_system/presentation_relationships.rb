module Powerpoint
  class FileSystem

    class PresentationRelationships
      def initialize(presentation)
        @presentation = presentation
      end

      attr_reader :presentation

      def relative_filepath
        "ppt/_rels/presentation.xml.rels"
      end

      def filepath
        "#{presentation.target_filepath}/#{relative_filepath}"
      end

      def data
        @data ||= Nokogiri::XML(File.read(filepath))
      end

      def add_slide(slide_number)
        relationships_node = data.children.first

        relationship = Nokogiri::XML::Node.new "Relationship", data
        relationship["Id"] = "rId#{presentation.highest_relationship_id + 1}"
        relationship["Target"] = "slides/slide#{slide_number}.xml"
        relationship["Type"] = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide"
        puts relationship.to_s
        relationships_node.add_child(relationship)
      end

      def save
        puts "[S]aving the PresentationRelationship"
        File.write(filepath,data.to_xml)
        @data = nil
      end

    end

  end
end