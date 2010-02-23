module Cucumber2RSpec #:nodoc:

  # ...
  class Step
    attr_reader :scenario, :_step

    def self.code_for_steps steps
      the_code = ''
      groups   = {
        'Given' => [],
        'When'  => [],
        'Then'  => []
      }

      last_keyword = 'Given'
      steps.each do |step|
        keyword = (step.keyword == 'And') ? last_keyword : step.keyword
        groups[keyword] << step.code
        last_keyword = step.keyword unless step.keyword == 'And'
      end

      groups['Given'].each {|code| the_code << (code.indent(4) + "\n") }
      the_code << "\n" if groups['Given'].length > 0
      
      groups['When' ].each {|code| the_code << (code.indent(4) + "\n") }
      the_code << "\n" if groups['When'].length > 0

      groups['Then' ].each {|code| the_code << (code.indent(4) + "\n") }
      the_code
    end

    def initialize scenario, cucumber_ast_step_invocation
      @scenario = scenario
      @_step    = cucumber_ast_step_invocation # Cucumber::Ast::StepInvocation
    end

    def keyword
      _step.respond_to?(:actual_keyword) ? _step.actual_keyword : _step.keyword
    end

    def table
      _step.multiline_arg if _step.respond_to?(:multiline_arg)
    end

    def has_table?
      !! table
    end

    def text
      if has_table?
        _step.to_sexp[ _step.to_sexp.length - 2 ] # the last argument will be the table!
      else
        _step.to_sexp.last
      end
    end

    def full_text
      "#{keyword} #{text}"
    end

    def _step_definition
      Cucumber2RSpec.step_match(text).instance_variable_get('@step_definition')
    end

    def regexp
      Regexp.new _step_definition.instance_variable_get('@regexp')
    end

    def raw_variable_names
      Cucumber2RSpec.block_variable_names(the_proc)
    end

    def variable_names
      # if has_table? then we ignore the last block variable (which is the table)
      variables = raw_variable_names
      variables.pop if has_table?
      variables
    end

    def table_variable_name
      raw_variable_names.last if has_table?
    end

    def the_proc
      _step_definition.instance_variable_get('@proc')
    end

    def matches
      return [] if variable_names.empty?

      match = text.match(regexp)
      if match
        matches = {}
        if match.captures.length != variable_names.length
          raise "Problem getting #{ variable_names.inspect } from #{ text.inspect }."
        end
        variable_names.each_with_index do |name, i|
          matches[name] = match.captures[i]
        end
        matches
      else
        []
      end
    end

    def code
      Cucumber2RSpec.log { '    ' + text }

      if has_table?
        # require cucumber and create a local variable defining the cucumber table
        header = "require 'cucumber'\n"
        header << "#{table_variable_name} = Cucumber::Ast::Table.new(#{ table.raw.inspect })\n"
      end

      if variable_names.empty?
        ruby = the_proc.to_ruby

        if has_table?
          # get rid of proc { |table| }
          ruby = ruby.sub(/^proc \{ \|#{table_variable_name}\|\s+/, '').sub(/\s\}$/, '')
        else
          # get rid of proc { }
          ruby = ruby.sub(/^proc \{\s+/, '').sub(/\s\}$/, '')
        end

      else
        # TODO replace with the_proc.to_sexp
        sexp_for_proc = ParseTree.new.process(the_proc.to_ruby) # turn the proc into an Sexp
        matches.each do |name, value|
          str = Sexp.new(:str, value)

          # s(:lvar, :var) => s(:str, "dogs")
          Cucumber2RSpec.replace_in_sexp sexp_for_proc, Sexp.new(:lvar, name), str

          # s(:evstr, s(:str, "dogs")) => s(:str, "dogs")
          Cucumber2RSpec.replace_in_sexp sexp_for_proc, Sexp.new(:evstr, str), str
        end
        ruby = Ruby2Ruby.new.process(sexp_for_proc) # turn it back into ruby
        if ruby =~ /^proc do/
          # get rid of the proc do |x| end
          ruby = ruby.sub(/^proc do \|([\w+, ]+)\|\n  /, '').sub(/\send$/, '')
        elsif ruby =~ /^proc \{ |/
          # get rid of proc { |whatever, ...| }
          ruby = ruby.sub(/^proc \{ \|([^\|]+)\|\s+/, '').sub(/\s\}$/, '')
        elsif ruby =~ /^proc \{/
          # get rid of proc { }
          ruby = ruby.sub(/^proc \{\s+/, '').sub(/\s\}$/, '')
        else
          raise "Not sure how to clean up the code for: #{ ruby }"
        end
      end

      ruby = header + ruby if has_table?

      # get rid of any spaces after any newlines
      ruby.gsub(/\n[ ]+/, "\n")
    end
  end
end
