module Spid
  module Rails
    # Your code goes here...
    module LocalInstanceMethods
      def squawk(string)
        write_attribute(self.class.yaffle_text_field, string.to_squawk)
      end
    end
  end
end
