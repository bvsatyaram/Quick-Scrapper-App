class ScrapperController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # Scraps the content of a *css_selector* within a webpage with url *target_url*
  #
  # Params:
  ## :target_url => CGI escaped url of thepage to be scrapped
  ## :css_selector => CGI escaped css selector of the element to be scrapped
  ## :ele_id => id of the element whose content need to be updated with the scrapped selection
  ## :first_word_index (optional) => Index of the first word in the scrapped content to be considered as selection
  ## :last_word_index (optional) => Index of the last word in the scrapped content to be considered as selection
  def scrap
    target_url = CGI.unescape(params[:target_url])
    css_selector = CGI.unescape(params[:css_selector])
    @element_id = params[:ele_id]

    @scrapped_text = QuickScrapper.scrap(target_url, css_selector)
    first_word_index = params[:first_word_index] || 0
    last_word_index = params[:last_word_index] || -1

    @scrapped_text = @scrapped_text.split[first_word_index..last_word_index].join(" ")
    render :text => "jQuery('#{@element_id}').html('#{@scrapped_text}');"
  end
end
