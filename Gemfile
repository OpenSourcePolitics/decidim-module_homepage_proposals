# frozen_string_literal: true

source "https://rubygems.org"
base_path = File.basename(__dir__) == "development_app" ? "../" : ""
require_relative "#{base_path}lib/decidim/homepage_proposals/version"

DECIDIM_VERSION = Decidim::HomepageProposals.decidim_version

ruby RUBY_VERSION

gem "decidim", "~> #{DECIDIM_VERSION}"
gem "decidim-homepage_proposals", path: "."

gem "bootsnap", "~> 1.4"
gem "puma", ">= 4.3"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "~> #{DECIDIM_VERSION}"
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end
