module Powerpoint
  module FileSystem

    class ContentTypes

      def initialize(presentation)
        @presentation = presentation
      end

      attr_reader :presentation

      # In the future, I picture a superclass or module that takes care of the
      # data reading and the data writing. At most the class will have to
      # implement is the relative_filepath method and the important methods for
      # the file

      def relative_filepath
        "[Content_Types].xml"
      end

      def filepath
        "#{presentation.target_filepath}/#{relative_filepath}"
      end

      def data
        @data ||= Nokogiri::XML(File.read(filepath))
      end

      def add_slide(slide_number)
        types_node = data.children.first

        slide = Nokogiri::XML::Node.new "Override", data
        slide["ContentType"] = "application/vnd.openxmlformats-officedocument.presentationml.slide+xml"
        slide["PartName"] = "/ppt/slides/slide#{slide_number}.xml"
        # puts slide.to_s
        types_node.add_child(slide)
      end

      def save
        File.write(filepath,data.to_xml)
        @data = nil
      end

    end
  end
end