module DailyEt
  VERSION = "0.1.0"

  class DayEt
    property date : String
    property day_of_year : Int32
    property et : Hash(String, Float64)

    def initialize(@date, doy)
      @day_of_year = doy.to_f.to_i
      @et = {} of String => Float64
    end

    def add_data(t, data)
      value = data.to_f
      @et[t] = (value / 28.4) unless value.nan?
    end

    def average
      return 0.0 if @et.empty?
      values = @et.values
      (values.sum / values.size).round(3)
    end
  end

  class YearEt
    property year : String
    property path : String
    property et : Hash(String, DayEt)

    def initialize(@year, @path)
      @et = {} of String => DayEt

      Dir.each_child @path do |name|
        next if name == year + ".txt"
        file_path = File.join(@path, name)
        process_file(file_path)
      end
    end

    def process_file(file)
      lines = File.read_lines(file)
      date_index = 0
      doy_index = 0
      time_index = 0
      data_index = 0
      qc_index = 0
      lines.each do |line|
        columns = line.split("\t")
        next if columns.empty?

        if columns[0] == "DATAH"
          columns.each_with_index do |s, i|
            date_index = i if s.strip == "date"
            time_index = i if s.strip == "time"
            doy_index = i if s.strip == "DOY"
            data_index = i if s.strip == "LE"
            qc_index = i if s.strip == "qc_LE"
          end
        end

        if columns[0] == "DATA"
          date = columns[date_index]
          next unless date.starts_with? (@year + "-")
          time = columns[time_index]
          doy = columns[doy_index]
          data = columns[data_index]
          qc = columns[qc_index].to_i?
          et[date] = DayEt.new(date, doy) unless @et.has_key? date
          et[date].add_data(time, data) if ((!qc.nil?) && qc < 2)
        end
      end
    end

    def output
      puts "DATE\tDOY\tAVERAGE_ET\tNUM_OF_DATA\n"
      dates = @et.keys
      dates.sort.each do |date|
        d = @et[date]
        puts d.date + "\t" + d.day_of_year.to_s + "\t" + d.average.to_s + "\t" + d.et.size.to_s + "\n"
      end
    end
  end
end

puts "Need two arguments: year and data path!" unless ARGV.size == 2
year_et = DailyEt::YearEt.new ARGV[0], ARGV[1]
year_et.output
