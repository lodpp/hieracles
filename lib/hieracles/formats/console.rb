module Hieracles
  module Formats
    # format accepting colors
    # for display in the terminal
    class Console < Hieracles::Format
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
        @colors = {}
        super(node)
      end

      def info(_)
        back =  format("Node:       %s\n", @node.fqdn)
        back << format("Farm:       %s\n", @node.farm)
        back << format("Datacenter: %s\n", @node.datacenter)
        back << format("Country:    %s\n", @node.country)
        back
      end

      def files(_)
        @node.files.join("\n") + "\n"
      end

      def paths(_)
        @node.paths.join("\n") + "\n"
      end

      def build_head
        output = ''
        @node.files.each_with_index do |f, i|
          output << format("#{COLORS[i]}\n", "[#{i}] #{f}")
          @colors[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          filecolor_index = @colors[first[:file]]
          filecolor = COLORS[filecolor_index]
          output << format("#{filecolor} #{COLORS[5]} %s\n",
                           "[#{filecolor_index}]",
                            key,
                            first[:value].to_s.gsub('%', '%%')
                           )
          while value.count > 0
            overriden = value.shift
            filecolor_index = @colors[overriden[:file]]
            output << format("    #{COLORS[8]}\n",
                             "[#{filecolor_index}] #{k} #{overriden[:value]}"
                            )
          end
        end
        output
      end

      def build_modules_line(key, value)
        length = @node.modules.keys.reduce(0) do |a, x|
          (x.length > a) ? x.length : a
        end + 3
        val = '%s'
        val = COLOR[0] if /not found/i.match value
        val = COLOR[2] if /\(duplicate\)/i.match value
        format("%-#{length}s #{val}\n", [key, value])
      end

    end
  end
end
