require 'spec_helper'

describe(RCAP::CAP_1_0::Polygon) do
  describe('is not valid if it') do
    before(:each) do
      @polygon = RCAP::CAP_1_0::Polygon.new do |polygon|
        [1, 2, 1].each do |i|
          polygon.add_point do |point|
            point.lattitude = i
            point.longitude = i
          end
        end
      end
      @polygon.should(be_valid)
    end

    it('does not have a valid collection of points') do
      @polygon.points.first.lattitude = nil
      @polygon.should_not(be_valid)
    end
  end

  context('on initialization') do
    context('from XML') do
      before(:each) do
        @original_polygon = RCAP::CAP_1_0::Polygon.new do |polygon|
          3.times do |i|
            polygon.add_point do |point|
              point.lattitude = i
              point.longitude = i
            end
          end
        end
        @empty_original_polygon = RCAP::CAP_1_0::Polygon.new
        @alert = RCAP::CAP_1_0::Alert.new
        @alert.add_info do |info|
          info.add_area do |area|
            [@original_polygon, @empty_original_polygon].each do |original_polygon|
              area.add_polygon do |polygon|
                original_polygon.points.each do |original_point|
                  polygon.add_point do |point|
                    point.lattitude = original_point.lattitude
                    point.longitude = original_point.longitude
                  end
                end
              end
            end
          end
        end

        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new(@xml_string)
        @info_element = RCAP.xpath_first(@xml_document.root, RCAP::CAP_1_0::Info::XPATH, RCAP::CAP_1_0::Alert::XMLNS)
        @area_element = RCAP.xpath_first(@info_element, RCAP::CAP_1_0::Area::XPATH, RCAP::CAP_1_0::Alert::XMLNS)
        @polygon_element = RCAP.xpath_first(@area_element, RCAP::CAP_1_0::Polygon::XPATH, RCAP::CAP_1_0::Alert::XMLNS)
        @polygon = RCAP::CAP_1_0::Polygon.from_xml_element(@polygon_element)
      end

      it('should parse all the points') do
        @polygon.points.zip(@original_polygon.points).each do |point, original_point|
          point.lattitude.should == original_point.lattitude
          point.longitude.should == original_point.longitude
        end
      end

      it 'should allow empty polygon xml elements' do
        empty_polygon_element = RCAP.xpath_match(@area_element, RCAP::CAP_1_0::Polygon::XPATH, RCAP::CAP_1_0::Alert::XMLNS)[1]
        empty_polygon = RCAP::CAP_1_0::Polygon.from_xml_element(empty_polygon_element)
        empty_polygon.should == @empty_original_polygon
      end
    end

    context('from a hash') do
      before(:each) do
        @polygon = RCAP::CAP_1_0::Polygon.new do |polygon|
          3.times do |i|
            polygon.add_point do |point|
              point.lattitude = i
              point.longitude = i
            end
          end
        end
      end

      it('should load all the points') do
        @new_polygon = RCAP::CAP_1_0::Polygon.from_h(@polygon.to_h)
        @new_polygon.points.should == @polygon.points
      end
    end
  end

  context('when exported') do
    before(:each) do
      @polygon = RCAP::CAP_1_0::Polygon.new do |polygon|
        3.times do |i|
          polygon.add_point do |point|
            point.lattitude = i
            point.longitude = i
          end
        end
      end
    end

    context('to geojson') do
      it('should be valid geojson') do
        expected = '{"type":"Polygon","coordinates":[[[0,0],[1,1],[2,2]]]}'
        expect(@polygon.to_geojson).to eq expected
      end
    end

    context('to a hash') do
      it('should export correctly') do
        @polygon.to_h.should == { RCAP::CAP_1_0::Polygon::POINTS_KEY => @polygon.points.map { |point| point.to_a } }
      end
    end
  end

  describe('instance methods') do
    before(:each) do
      @polygon = RCAP::CAP_1_0::Polygon.new
    end

    describe('#add_point') do
      before(:each) do
        @point = @polygon.add_point do |polygon|
          polygon.lattitude = 1
          polygon.longitude = 1
        end
      end

      it('should return a 1.0 Point') do
        @point.class.should == RCAP::CAP_1_0::Point
        @point.lattitude.should == 1
        @point.longitude.should == 1
      end

      it('should add a Point to the points attribute') do
        @polygon.points.size.should == 1
      end
    end
  end
end
