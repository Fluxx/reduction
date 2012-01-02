require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'
require 'distillery'
require 'loofah'
require 'uri'

module Reduction
  class Strategy

    class General < Strategy

      def self.for_url?(url)
        !!(url.to_s.match(/^https?:\/\//))
      end

      def self.priority
        100
      end

      # Custom version of the whitewash scrubber that basically does the same
      # thing, but preserves hrefs in <a> tags and srcs.
      class Scrubber < Loofah::Scrubbers::Whitewash

        APPROVED_ATTRIBUTES = Hash.new({}).tap do |attr|
          attr['img'] = {'src' => true }
          attr['a']   = {'href' => true }
        end

        def scrub(node)
          case node.type
          when Nokogiri::XML::Node::ELEMENT_NODE
            if safe_element? node.name
              node.attributes.each do |attr|
                unless APPROVED_ATTRIBUTES[node.name][attr.first]
                  node.remove_attribute(attr.first)
                end
              end

              return CONTINUE if node.namespaces.empty?
            end
          when Nokogiri::XML::Node::TEXT_NODE, Nokogiri::XML::Node::CDATA_SECTION_NODE
            return CONTINUE
          end
          node.remove
          STOP
        end

        def safe_element?(name)
          ::Loofah::HTML5::Scrub.allowed_element?(name) ||
          name.start_with?('nyt')
        end

      end

      def body
        processed_body.inner_html
      end

      def title
        doc.at('title').text.collapse_whitespace
      end

      def ingredients
        []
      end

      def steps
        []
      end

      def yields
        ""
      end

      def cook_time
        ""
      end

      def prep_time
        ""
      end

      def total_time
        ""
      end

      def notes
        ""
      end

      def images
        processed_body.search('img').map do |img|
          make_absolute(img['src'])
        end
      end

      def type
        :general
      end

      private

      def processed_body
        @processed_body || begin
          distilled = Distillery.distill(@doc.to_s, images: true)
          whitewashed = Loofah.scrub_fragment(distilled, Scrubber.new).to_s

          doc = Nokogiri::HTML(whitewashed)

          doc.search('a', 'img').each do |e|
            %w[href src].each do |attr|
              e[attr] = make_absolute(e[attr]) if e[attr]
            end
          end

          doc.at('body')
        end
      end

      def host_uri
        @host_url ||= URI.parse(@url)
      end

      def make_absolute(relative_url)
        host_uri.merge(URI.parse(relative_url)).to_s
      end

    end

  end
end