module Hieracles

  class Dispatch

    COLORS = [
      "\e[31m%s\e[0m",
      "\e[32m%s\e[0m",
      "\e[33m%s\e[0m",
      "\e[34m%s\e[0m",
      "\e[35m%s\e[0m",
      "\e[36m%s\e[0m",
      "\e[37m%s\e[0m",
      "\e[38m%s\e[0m",
      "\e[97m%s\e[0m"
    ]

    def initialize(node)
      @node = node
    end

    def info(*args)
      puts [ @node.fqdn, @node.farm, @node.datacenter, @node.country ].join(',')
    end

    def files(*args)
      puts @node.files.join(',')
    end

    def paths(*args)
      puts @node.paths.join(',')
    end

    def params(args)
      filter = args[0]
      colors = {}
      output = ""
      output << show_head(colors)
      @node.params.each do |k, v|
        output <<show_params(k, v, filter, colors)
      end
      puts output
    end

    def allparams(args)
      @node.add_common
      params(args)
    end

    def modules(args)
      if Config.format == 'raw'
        @node.modules.each do |k, v|
          puts v
        end
      else
        length = @node.modules.keys.reduce(0) { |a, x| (x.length > a) ? x.length : a } + 3
        puts color(3) % [@node.classfile]
        puts
        @node.modules.each do |k, v|
          val = "%s"
          val = color(0) if /not found/i.match v 
          val = color(2) if /\(duplicate\)/i.match v 
          puts "%-#{length}s #{val}" % [k, v]
        end
      end
    end

  protected

    def show_head(colors)
      @node.files.each_with_index do |f,i|
        puts color(i) % "[#{i}] #{f}"
        colors[f] = i
      end
      puts
    end

    def show_params(key, value, filter, colors)
      if !filter || Regexp.new(filter).match(k)
        first = value.shift
        begin
          puts "#{color(colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}" % ["[#{colors[first[:file]]}]", key]
        rescue
          puts "--debug----"
          puts "#{color(colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}"
          puts "--/debug----"
        end
        while value.count > 0
          overriden = value.shift
          puts "    #{color(8)}" % ["[#{colors[overriden[:file]]}] #{k} #{overriden[:value]}"]
        end
      end
    end

    def color(c)
      if Config.colors
        COLORS[c]
      else
        "%s"
      end
    end

  end

end
