require 'test/unit'
require 'axlsx.rb'

class TestChart < Test::Unit::TestCase

  def setup
    @p = Axlsx::Package.new
    ws = @p.workbook.add_worksheet
    @row = ws.add_row ["one", 1, Time.now]
    @chart = ws.add_chart Axlsx::Bar3DChart, :title => "fishery"
  end

  def teardown
  end

  def test_initialization
    assert_equal(@p.workbook.charts.last,@chart, "the chart is in the workbook")
    assert_equal(@chart.title.text, "fishery", "the title option has been applied")
    assert((@chart.series.is_a?(Axlsx::SimpleTypedList) && @chart.series.empty?), "The series is initialized and empty") 
  end

  def test_title
    @chart.title.text = 'wowzer'
    assert_equal(@chart.title.text, "wowzer", "the title text via a string")
    assert_equal(@chart.title.cell, nil, "the title cell is nil as we set the title with text.")
    @chart.title.cell = @row.cells.first
    assert_equal(@chart.title.text, "one", "the title text was set via cell reference")
    assert_equal(@chart.title.cell, @row.cells.first)
  end


  def test_add_series    
    s = @chart.add_series :data=>[0,1,2,3], :labels => ["one", 1, "anything"], :title=>"bob"
    assert_equal(@chart.series.last, s, "series has been added to chart series collection")
    assert_equal(s.title, "bob", "series title has been applied")
    assert_equal(s.data, [0,1,2,3], "data option applied")
    assert_equal(s.labels, ["one",1,"anything"], "labels option applied")    
  end  
  
  def test_create_range
    
  end

  def test_pn
    assert_equal(@chart.pn, "charts/chart1.xml")
  end
 
  def test_to_xml
    schema = Nokogiri::XML::Schema(File.open(Axlsx::DRAWING_XSD))
    doc = Nokogiri::XML(@chart.to_xml)
    errors = []
    schema.validate(doc).each do |error|
      errors.push error
      puts error.message
    end
    assert(errors.empty?, "error free validation")
  end  
  
end
