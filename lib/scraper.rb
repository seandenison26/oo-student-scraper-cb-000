require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css('div.student-card')
    students.map { |student|
          Hash.new.tap { |hash|
            hash[:name] = student.css('div.card-text-container h4').text
            hash[:location] = student.css('div.card-text-container p').text
            hash[:profile_url] = "#{student.css('a').first["href"]}"
          }

    }
  end

  def self.scrape_profile_page(profile_url)
    page =  Nokogiri::HTML(open(profile_url))
    Hash.new.tap { |hash|
      page.css("div.social-icon-container a").map {|a|
        ref = a["href"]
        if ref.include?("twitter")
          hash[:twitter] = ref
        elsif ref.include?("linkedin")
          hash[:linkedin] = ref
        elsif ref.include?("github")
          hash[:github] = ref
        else
          hash[:blog] = ref
        end
      }
      hash[:profile_quote] = page.css("div.profile-quote").text
      hash[:bio] = page.css("div.description-holder p").text
    }
  end

end

#students = Scraper.scrape_index_page("./fixtures/student-site/index.html")
#profile = Scraper.scrape_profile_page(students[0][:profile_url])
