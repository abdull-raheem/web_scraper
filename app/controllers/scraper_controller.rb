class ScraperController < ApplicationController

	def data
		url = params[:url]
		fields = params[:fields]

		begin
			result = ScrapeWebsite.call(url, fields)
			render json: result
		rescue StandardError => e
		render json: { error: e.message }, status: :unprocessable_entity
		end
	end
end
  
