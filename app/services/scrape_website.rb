require 'open-uri'
require 'nokogiri'

class ScrapeWebsite < ApplicationService

	def initialize(url, fields)
		@url = url
		@fields = fields
	end


	def call
		scrape_data
	end

	def scrape_data
		begin
				html_content = fetch_html_content(@url)
				scrape_fields(html_content, @fields)
		rescue StandardError => e
			raise StandardError, { error: e.message }
		end
	end
		
	private
		
	def fetch_html_content(url)
		open(url).read
	rescue OpenURI::HTTPError => e
		raise StandardError, "HTTP Error: #{e.message}"
	end
	
	def scrape_fields(html_content, fields)
		result = {}
		doc = Nokogiri::HTML(html_content)
	
		fields.each do |field_name, selector|
			if field_name == 'meta'
				scrape_meta_field(result, doc, selector)
			else
				result[field_name] = doc.css(selector)&.text&.strip
			end
		end
		result
	end

	def scrape_meta_field(result, doc, selector)
		meta_result = {}
		selector.each do |meta_name|
			meta_result[meta_name] = doc.at_css("meta[name='#{meta_name}']")&.
																attribute('content')&.value
		end
		result['meta'] = meta_result
	end
      
end