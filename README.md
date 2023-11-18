# Template that includes devise, BS5
- The following are how features and config were applied.

## Postgres for all envs
- change database.yml for all pg
- `rails db:create`
- `rails s`  instead of  `bin/dev`

## bootstrap 5 & JS
[ref](https://www.linkedin.com/pulse/rails-7-bootstrap-52-importmap-md-habibur-rahman-habib)

## devise
- [github](https://github.com/heartcombo/devise#getting-started)
- [rails girls](https://guides.railsgirls.com/devise)
```
rails generate devise:install

<%= link_to "Sign out", destroy_user_session_path, data: { "turbo-method": :delete }, class: "nav-link" %>`

rails generate devise:views
  config/initializers/devise.rb`=>`config.scoped_views = true
```
[adding extra fields](https://gist.github.com/withoutwax/46a05861aa4750384df971b641170407)
```
rails generate migration add_token_to_users token:string
```
Depending on your application's configuration some manual setup may be required:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in `config/environments/development.rb`:
```
       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
     In production, `:host` should be set to the actual host of your application.

     * Required for all applications. *

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:
```
       root to: "home#index"
```    
     * Not required for API-only Applications *

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:
```
       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>
```
     * Not required for API-only Applications *

  4. You can copy Devise views (for customization) to your app by running:
```
       rails g devise:views
```       
     * Not required *

# Derived from appdev's Rails Template

This is a base Ruby on Rails repository configured for learning with Codespaces (and Gitpod).

- Ruby version: `3.2.1`
- Rails version: `7.0.4.3`


We've added additional Ruby gems and other software that aren't automatically available in a new Rails app.

### Additional gems:

- [`appdev_support`](https://github.com/firstdraft/appdev_support)
- [`annotate`](https://github.com/ctran/annotate_models)
- [`awesome_print`](https://github.com/awesome-print/awesome_print)
- [`better_errors`](https://github.com/BetterErrors/better_errors)
- [`binding_of_caller`](https://github.com/banister/binding_of_caller)
- [`dotenv-rails`](https://github.com/bkeepers/dotenv)
- [`draft_generators`](https://github.com/firstdraft/draft_generators/)
- [`draft_matchers`](https://github.com/jelaniwoods/draft_matchers/)
- [`devise`](https://github.com/heartcombo/devise)
- [`faker`](https://github.com/faker-ruby/faker)
- [`grade_runner`](https://github.com/firstdraft/grade_runner/)
- [`htmlbeautifier`](https://github.com/threedaymonk/htmlbeautifier/)
- [`http`](https://github.com/httprb/http)
- [`pry_rails`](https://github.com/pry/pry-rails)
- [`rails_db`](https://github.com/igorkasyanchuk/rails_db)
- [`rails-erd`](https://github.com/voormedia/rails-erd)
- [`rspec-html-matchers`](https://github.com/kucaahbe/rspec-html-matchers)
- [`rspec-rails`](https://github.com/rspec/rspec-rails)
- [`rufo`](https://github.com/ruby-formatter/rufo)
- [`specs_to_readme`](https://github.com/firstdraft/specs_to_readme)
- [`table_print`](https://github.com/arches/table_print)
- [`web_git`](https://github.com/firstdraft/web_git)
- [`webmock`](https://github.com/bblimke/webmock)

### Additional software:
- OS Ubuntu 20.04.5 LTS
- Chromedriver
- Fly.io's `flyctl`
- Google Chrome (headless browser)
- Graphviz
- Heroku 
- Node JS 18
- NPM 8.19.3
- Parity
- Postgresql 12
- Redis
- Yarn

### VS Code extensions:
- aliariff.vscode-erb-beautify
- mbessey.vscode-rufo
- vortizhe.simple-ruby-erb
