# Application Generator Template
# Modifies a Rails app to set up Haml with an HTML5 application layout and options for CSS with Twitter Bootstrap
# Usage: rails new APP_NAME -m https://github.com/RailsApps/rails3-application-templates/raw/master/rails3-haml-html5-template.rb

# Generated using the rails_apps_composer gem:
# https://github.com/RailsApps/rails_apps_composer/

# Based on application template recipes by:
# Michael Bleigh https://github.com/mbleigh
# Daniel Kehoe https://github.com/DanielKehoe

# If you are customizing this template, you can use any methods provided by Thor::Actions
# http://rdoc.info/rdoc/wycats/thor/blob/f939a3e8a854616784cac1dcff04ef4f3ee5f7ff/Thor/Actions.html
# and Rails::Generators::Actions
# http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb

# >---------------------------------------------------------------------------<
#
#            _____       _ _   __          ___                  _ 
#           |  __ \     (_) |  \ \        / (_)                | |
#           | |__) |__ _ _| |___\ \  /\  / / _ ______ _ _ __ __| |
#           |  _  // _` | | / __|\ \/  \/ / | |_  / _` | '__/ _` |
#           | | \ \ (_| | | \__ \ \  /\  /  | |/ / (_| | | | (_| |
#           |_|  \_\__,_|_|_|___/  \/  \/   |_/___\__,_|_|  \__,_|
#
#   This template was generated by rails_apps_composer, a custom version of
#   RailsWizard, the application template builder. For more information, see:
#   https://github.com/RailsApps/rails_apps_composer/
#
# >---------------------------------------------------------------------------<

# >----------------------------[ Initial Setup ]------------------------------<

initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY

@recipes = ["haml", "home_page", "html5", "cleanup", "extras", "git"]

def recipes; @recipes end
def recipe?(name); @recipes.include?(name) end

def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'wizard', text) end

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + (@current_recipe || "prompt").rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i| 
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block); @after_blocks << [@current_recipe, block]; end
@after_everything_blocks = []
def after_everything(&block); @after_everything_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end


# this application template only supports Rails version 3.1 and newer
case Rails::VERSION::MAJOR.to_s
when "3"
  case Rails::VERSION::MINOR.to_s
  when "2"
    say_wizard "You are using Rails version #{Rails::VERSION::STRING}."
  when "1"
    say_wizard "You are using Rails version #{Rails::VERSION::STRING}."
  when "0"
    say_wizard "You are using Rails version #{Rails::VERSION::STRING} which is not supported. Try 3.1 or newer."
    raise StandardError.new "Rails #{Rails::VERSION::STRING} is not supported. Try 3.1 or newer."
  else
    say_wizard "You are using Rails version #{Rails::VERSION::STRING}."
  end
else
  say_wizard "You are using Rails version #{Rails::VERSION::STRING} which is not supported. Try 3.1 or newer."
  raise StandardError.new "Rails #{Rails::VERSION::STRING} is not supported. Try 3.1 or newer."
end

say_wizard "Checking configuration. Please confirm your preferences."

# >---------------------------[ Autoload Modules/Classes ]-----------------------------<

inject_into_file 'config/application.rb', :after => 'config.autoload_paths += %W(#{config.root}/extras)' do <<-'RUBY'

    config.autoload_paths += %W(#{config.root}/lib)
RUBY
end

# >---------------------------------[ Recipes ]----------------------------------<


# >---------------------------------[ HAML ]----------------------------------<

@current_recipe = "haml"
@before_configs["haml"].call if @before_configs["haml"]
say_recipe 'HAML'

config = {}
config['haml'] = yes_wizard?("Would you like to use Haml instead of ERB?") if true && true unless config.key?('haml')
@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/haml.rb

if config['haml']
  gem 'haml', '>= 3.1.4'
  gem 'haml-rails', '>= 0.3.4', :group => :development
else
  recipes.delete('haml')
end


# >-------------------------------[ HomePage ]--------------------------------<

@current_recipe = "home_page"
@before_configs["home_page"].call if @before_configs["home_page"]
say_recipe 'HomePage'


@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/home_page.rb

after_bundler do
  
  say_wizard "HomePage recipe running 'after bundler'"
  
  # remove the default home page
  remove_file 'public/index.html'
  
  # create a home controller and view
  generate(:controller, "home index")

  # set up a simple home page (with placeholder content)
  if recipes.include? 'haml'
    remove_file 'app/views/home/index.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/views/home/index.html.haml' do 
    <<-'HAML'
%h3 Home
HAML
    end
  elsif recipes.include? 'slim'
    # skip
  else
    remove_file 'app/views/home/index.html.erb'
    create_file 'app/views/home/index.html.erb' do 
    <<-ERB
<h3>Home</h3>
ERB
    end
  end

  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

  if recipes.include? 'devise'
    inject_into_file 'config/routes.rb', :before => "  root :to" do 
    <<-RUBY
  authenticated :user do
    root :to => 'home#index'
  end
\n  
RUBY
    end
  end

end


# >---------------------------------[ html5 ]---------------------------------<

@current_recipe = "html5"
@before_configs["html5"].call if @before_configs["html5"]
say_recipe 'html5'

config = {}
config['css_option'] = multiple_choice("Which front-end framework would you like for HTML5 and CSS?", [["None", "nothing"], ["Zurb Foundation", "foundation"], ["Twitter Bootstrap (less)", "bootstrap_less"], ["Twitter Bootstrap (sass)", "bootstrap_sass"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]]) if true && true unless config.key?('css_option')
@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

case config['css_option']

  when 'foundation'
    # https://github.com/zurb/foundation-rails
    gem 'zurb-foundation'

  when 'bootstrap_less'
    # https://github.com/seyhunak/twitter-bootstrap-rails
    # http://railscasts.com/episodes/328-twitter-bootstrap-basics
    gem 'twitter-bootstrap-rails', '>= 2.0.3', :group => :assets
    recipes << 'bootstrap'

  when 'bootstrap_sass'
    # https://github.com/thomas-mcdonald/bootstrap-sass
    # http://rubysource.com/twitter-bootstrap-less-and-sass-understanding-your-options-for-rails-3-1/
    gem 'bootstrap-sass', '>= 2.0.1'
    recipes << 'bootstrap'

end
after_bundler do
  say_wizard "HTML5 recipe running 'after bundler'"
  # add a humans.txt file
  get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/humans.txt', 'public/humans.txt'
  # install a front-end framework for HTML5 and CSS3
  remove_file 'app/assets/stylesheets/application.css'
  remove_file 'app/views/layouts/application.html.erb'
  remove_file 'app/views/layouts/application.html.haml'
  unless recipes.include? 'bootstrap'
    if recipes.include? 'haml'
      # Haml version of a simple application layout
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/simple/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/simple/views/layouts/_messages.html.haml', 'app/views/layouts/_messages.html.haml'
    else
      # ERB version of a simple application layout
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/simple/views/layouts/application.html.erb', 'app/views/layouts/application.html.erb'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/simple/views/layouts/_messages.html.erb', 'app/views/layouts/_messages.html.erb'
    end
    # simple css styles
    get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/simple/assets/stylesheets/application.css.scss', 'app/assets/stylesheets/application.css.scss'  
  else # for Twitter Bootstrap
    if recipes.include? 'haml'
      # Haml version of a complex application layout using Twitter Bootstrap
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/_messages.html.haml', 'app/views/layouts/_messages.html.haml'
    else
      # ERB version of a complex application layout using Twitter Bootstrap
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/application.html.erb', 'app/views/layouts/application.html.erb'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/_messages.html.erb', 'app/views/layouts/_messages.html.erb'
    end
    # complex css styles using Twitter Bootstrap
    get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/assets/stylesheets/application.css.scss', 'app/assets/stylesheets/application.css.scss'
  end
  # get an appropriate navigation partial
  if recipes.include? 'haml'
    if recipes.include? 'devise'
      if recipes.include? 'authorization'
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/devise/authorization/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
      else
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/devise/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'        
      end
    elsif recipes.include? 'omniauth'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/omniauth/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
    elsif recipes.include? 'subdomains'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/subdomains/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
    else
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/none/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
    end
  else
    if recipes.include? 'devise'
      if recipes.include? 'authorization'
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/devise/authorization/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
      else
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/devise/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'        
      end
    elsif recipes.include? 'omniauth'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/omniauth/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
    elsif recipes.include? 'subdomains'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/subdomains/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
    else
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/none/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
    end
  end
  if recipes.include? 'haml'
    gsub_file 'app/views/layouts/application.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_navigation.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
  else
    gsub_file 'app/views/layouts/application.html.erb', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_navigation.html.erb', /App_Name/, "#{app_name.humanize.titleize}"
  end
  case config['css_option']

    when 'bootstrap_less'
      say_wizard 'installing Twitter Bootstrap HTML5 framework (less)'
      generate 'bootstrap:install'
      remove_file 'app/assets/stylesheets/application.css' # already created application.css.scss above
      insert_into_file 'app/assets/stylesheets/bootstrap_and_overrides.css.less', "body { padding-top: 60px; }\n", :after => "@import \"twitter/bootstrap/bootstrap\";\n"

    when 'bootstrap_sass'
      say_wizard 'installing Twitter Bootstrap HTML5 framework (sass)'
      insert_into_file 'app/assets/javascripts/application.js', "//= require bootstrap\n", :after => "jquery_ujs\n"
      create_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', <<-RUBY
// Set the correct sprite paths
$iconSpritePath: image-path('glyphicons-halflings.png');
$iconWhiteSpritePath: image-path('glyphicons-halflings-white.png');
@import "bootstrap";
body { padding-top: 60px; }
@import "bootstrap-responsive";
RUBY

    when 'foundation'
      say_wizard 'installing Zurb Foundation HTML5 framework'
      insert_into_file 'app/assets/javascripts/application.js', "//= require foundation\n", :after => "jquery_ujs\n"
      insert_into_file 'app/assets/stylesheets/application.css.scss', " *= require foundation\n", :after => "require_self\n"

    when 'skeleton'
      say_wizard 'installing Skeleton HTML5 framework'
      get 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 'app/assets/stylesheets/normalize.css.scss'
      get 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css', 'app/assets/stylesheets/base.css.scss'
      get 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css', 'app/assets/stylesheets/layout.css.scss'
      get 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css', 'app/assets/stylesheets/skeleton.css.scss'
      get 'https://raw.github.com/dhgamache/Skeleton/master/javascripts/tabs.js', 'app/assets/javascripts/tabs.js'

    when 'normalize'
      say_wizard 'normalizing CSS for consistent styling'
      get 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 'app/assets/stylesheets/normalize.css.scss'

    when 'nothing'
      say_wizard 'no HTML5 front-end framework selected'

  end

end


# >--------------------------------[ Cleanup ]--------------------------------<

@current_recipe = "cleanup"
@before_configs["cleanup"].call if @before_configs["cleanup"]
say_recipe 'Cleanup'


@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/cleanup.rb

after_bundler do

  say_wizard "Cleanup recipe running 'after bundler'"

  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }

  # add placeholder READMEs
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.txt", "README"
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.textile", "README.textile"
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

  # remove commented lines and multiple blank lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"

  # remove commented lines and multiple blank lines from config/routes.rb
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
  
end


# >--------------------------------[ Extras ]---------------------------------<

@current_recipe = "extras"
@before_configs["extras"].call if @before_configs["extras"]
say_recipe 'Extras'

config = {}
config['footnotes'] = yes_wizard?("Would you like to use 'rails-footnotes' (it's SLOW!)?") if true && true unless config.key?('footnotes')
config['ban_spiders'] = yes_wizard?("Would you like to set a robots.txt file to ban spiders?") if true && true unless config.key?('ban_spiders')
config['paginate'] = yes_wizard?("Would you like to add 'will_paginate' for pagination?") if true && true unless config.key?('paginate')
@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['footnotes']
  say_wizard "Adding 'rails-footnotes'"
  gem 'rails-footnotes', '>= 3.7', :group => :development
  after_bundler do
    generate 'rails_footnotes:install'
  end
end

if config['ban_spiders']
  say_wizard "Banning spiders by modifying 'public/robots.txt'"
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

if config['paginate']
  say_wizard "Adding 'will_paginate'"
  if recipes.include? 'mongoid'
    gem 'will_paginate_mongoid'
  else
    gem 'will_paginate', '>= 3.0.3'
  end
  recipes << 'paginate'
end


# >----------------------------------[ Git ]----------------------------------<

@current_recipe = "git"
@before_configs["git"].call if @before_configs["git"]
say_recipe 'Git'


@configs[@current_recipe] = config

# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/git.rb

after_everything do
  
  say_wizard "Git recipe running 'after everything'"
  
  # Git should ignore some files
  remove_file '.gitignore'
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/gitignore.txt", ".gitignore"

  if recipes.include? 'omniauth'
    append_file '.gitignore' do <<-TXT

# keep OmniAuth service provider secrets out of the Git repo
config/initializers/omniauth.rb
TXT
    end
  end

  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'new Rails app generated by Rails Apps Composer gem'"
  # Create a git branch
  git :checkout => ' -b working_branch'
  git :add => '.'
  git :commit => "-m 'Initial commit of working_branch'"
  git :checkout => 'master'
end





@current_recipe = nil

# >-----------------------------[ Run Bundler ]-------------------------------<

say_wizard "Running 'bundle install'. This will take a while."
run 'bundle install'
run 'bundle update'
say_wizard "Running 'after bundler' callbacks."
require 'bundler/setup'
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Running 'after everything' callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Finished running the rails_apps_composer app template."
say_wizard "Your new Rails app is ready."
