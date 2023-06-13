# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_module_homepage_proposals do
  namespace :webpacker do
    desc "Installs Decidim Awesome webpacker files in Rails instance application"
    task install: :environment do
      puts "install NPM packages. You can also do this manually with this command:"
      puts "npm i --save glidejs"
      system! "npm i --save glidejs"
    end
  end
end
