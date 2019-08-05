require "http/client"
require "json"

module ReferenceEt
  VERSION = "0.1.0"

  class DayEt
    property lat : Float64
    property lng : Float64
    property date = ""
    property day_of_year = 0
    property et = 0.0
    property points = 0
    property ref : Float64?
    property ref_location = ""

    def initialize(@lat, @lng, line, old_data)
      ss = line.split("\t")
      @date = ss[0]
      @day_of_year = ss[1].to_i
      @et = ss[2].to_f
      @points = ss[3].to_i
      @ref = nil
      if old_data.has_key? @date
        old_ss = old_data[@date].split("\t")
        if (old_ss.size > 4 && !old_ss[4].empty? && old_ss[4].strip != "0.0")
          @ref = old_ss[4].to_f
          @ref_location = old_ss[5] if (old_ss.size > 5)
        end
      end
      get_reference if @ref.nil?
    end

    def get_reference
      dd = @date.split("-")
      form_data = "map=a1440&month=#{dd[1].to_i}&day=#{dd[2].to_i}&year=#{dd[0].to_i}"
      response = HTTP::Client.post "http://awdn.unl.edu/aim/data.php", form: form_data
      return if response.status_code != 200
      data = JSON.parse(response.body)

      dist = -1.0
      data["geojson"]["features"].as_a.each do |station|
        lat = station["geometry"]["coordinates"][0].to_s.to_f
        lng = station["geometry"]["coordinates"][1].to_s.to_f
        d = (lat - @lat)*(lat - @lat) + (lng - @lng)*(lng - @lng)
        if (dist < 0 || d < dist)
          dist = d
          @ref = (station["data"][7]["value"].to_s.to_f*25.4).round(3)
          @ref_location = "#{lat},#{lng}"
        end
      end
    end
  end

  class YearEt
    property path : String
    property lat : Float64
    property lng : Float64
    property et : Array(DayEt)
    property output_file : String

    def initialize(@path, @output_file, latlng)
      @et = [] of DayEt
      ll = latlng.split(",")
      @lat = ll[0].to_f
      @lng = ll[1].to_f

      old_data = {} of String => String
      if (!@output_file.empty? && File.file? @output_file)
        old_lines = File.read_lines(@output_file)
        old_lines.shift
        old_lines.each do |l|
          next if l.empty?
          ss = l.split("\t")
          old_data[ss[0]] = l
        end
      end

      lines = File.read_lines(@path)
      lines.shift
      lines.each do |line|
        @et << DayEt.new(@lat, @lng, line, old_data) unless line.empty?
      end
    end

    def output
      s = String.build do |str|
        str << "DATE\tDOY\tAVERAGE_ET\tNUM_OF_DATA\tREFERENCE_ET\tREFERENCE_LOCATION\n"
        @et.each do |d|
          str << "#{d.date}\t#{d.day_of_year}\t#{d.et}\t#{d.points}\t#{d.ref}\t#{d.ref_location}\n"
        end
      end
      if @output_file.empty?
        puts s
      else
        File.write(@output_file, s)
      end
    end
  end
end

puts "Need at least 2 arguments: et source and latitude,longitude!" unless ARGV.size >= 2
output_file = ""
output_file = ARGV[2] if ARGV.size >= 3

year_et = ReferenceEt::YearEt.new ARGV[0], output_file, ARGV[1]
year_et.output
