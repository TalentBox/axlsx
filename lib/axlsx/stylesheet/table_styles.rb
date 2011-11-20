module Axlsx
  # TableStyles represents a collection of style definitions for table styles and pivot table styles.
  # @note Support for custom table styles does not exist in this version. Many of the classes required are defined in preparation for future release. Please do not attempt to add custom table styles.
  class TableStyles < SimpleTypedList

    # The default table style. The default value is 'TableStyleMedium9'
    # @return [String]
    # 
    attr_accessor :defaultTableStyle

    # The default pivot table style. The default value is  'PivotStyleLight6'
    # @return [String]
    attr_accessor :defaultPivotStyle
    
    # Creates a new TableStyles object that is a container for TableStyle objects
    # @option options [String] defaultTableStyle
    # @option options [String] defaultPivotStyle
    def initialize(options={})
      @defaultTableStyle = options[:defaultTableStyle] || "TableStyleMedium9"
      @defaultPivotStyle = options[:defaultPivotStyle] || "PivotStyleLight16"      
      super TableStyle
    end

    def defaultTableStyle=(v) Axlsx::validate_string(v); @defaultTableStyle = v; end
    def defaultPivotStyle=(v) Axlsx::validate_string(v); @defaultPivotStyle = v; end

    # Serializes the table styles element
    # @param [Nokogiri::XML::Builder] xml The document builder instance this objects xml will be added to.
    # @return [String]
    def to_xml(xml)
      attr = self.instance_values.reject {|k, v| ![:defaultTableStyle, :defaultPivotStyle].include?(k.to_sym) }
      attr[:count] = self.size
      xml.tableStyles(attr) {
        self.each { |table_style| table_style.to_xml(xml) }
      }
    end
  end

end
