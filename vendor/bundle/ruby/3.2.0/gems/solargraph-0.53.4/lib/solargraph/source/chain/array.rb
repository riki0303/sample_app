module Solargraph
  class Source
    class Chain
      class Array < Literal
        # @param children [::Array<Chain>]
        def initialize children
          super('::Array')
          @children = children
        end

        def word
          @word ||= "<#{@type}>"
        end

        # @param api_map [ApiMap]
        # @param name_pin [Pin::Base]
        # @param locals [Enumerable<Pin::LocalVariable>]
        def resolve api_map, name_pin, locals
          child_types = @children.map do |child|
            child.infer(api_map, name_pin, locals).tag
          end
          type = if child_types.uniq.length == 1 && child_types.first != 'undefined'
                   "::Array<#{child_types.first}>"
                 else
                   '::Array'
                 end
          [Pin::ProxyType.anonymous(ComplexType.try_parse(type))]
        end
      end
    end
  end
end
