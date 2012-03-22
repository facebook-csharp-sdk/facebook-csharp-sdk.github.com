module Jekyll

  class CodeTabBlock < Liquid::Block
    include Liquid::StandardFilters

    # The regular expression syntax checker. Start with the language specifier.
    # Follow that by zero or more space separated options that take one of two
    # forms:
    #
    # 1. name
    # 2. name=value
    SYNTAX = /^([a-zA-Z0-9.+#-]+)((\s+\w+(=\w+)?)*)$/

    def initialize(tag_name, markup, tokens)
      super
      if markup.strip =~ SYNTAX
        @lang = $1
        if defined?($2) && $2 != ''
          tmp_options = {}
          $2.split.each do |opt|
            key, value = opt.split('=')
            if value.nil?
                value = true
            end
            tmp_options[key] = value
          end
          @options = tmp_options
        else
          @options = {}
        end
      else
        raise SyntaxError.new("Syntax Error in 'highlight' - Valid syntax: highlight <lang> [id=tabname] [active]")
      end
    end

    def render(context)
        render_codehighlighter(context, super)
    end

    def render_codehighlighter(context, code)
      tabclass = 'tab-pane'
      if @options['active']
        tabclass += ' active'
      end
      #The div is required because RDiscount blows ass
      <<-HTML
<div class="#{tabclass}" id="#{@options['id']}">
  <pre><code class='prettyprint lang-#{@lang}'>#{h(code).strip}</code></pre>
</div>
      HTML
    end

  end

end

Liquid::Template.register_tag('codetab', Jekyll::CodeTabBlock)