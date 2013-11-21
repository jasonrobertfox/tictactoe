#App Documentation

> This is where you can plop your app's documentation :)

##Sinatra Boilerplate Documentation
The below should be universally applicable from the original [sinatra-boilerplate](https://github.com/neverstopbuilding/sinatra-boilerplate)

Here is a Sinatra Boilerplate app that will let you get started developing something fast and do it in a clean, test-driven way. This is a one stop shop.

###Features
- RSpec and Rack::Unit test support with Capybara for web testing.
- System and Unit tests organized and optimized.
- Code quality managed by Rubocop
- Assets packaged and Minified
- Unit test coverage and Test reporting built in.
- Zurb Foundation and Compass support fresh layouts.
- Slim templates.
- Simple configuration.
- Guard with Live Reload for fast development.
- Deploys to Heroku out of the box.

###Making It Your Own

Simple:

1. Clone this repository.
2. Initialize a new git repository for your project.
3. Install the dependencies: `bundle install`
4. Update the contents of `lib/config/config.yml`, `lib/public/humans.txt`, `lib/views/index.slim`, and `spec/system/lib/views/index_spec.rb` to suit your needs.
5. Run `bundle exec guard` to start the development server and testing features.
6. Away you go!

###Slim Templates
This boilerplate uses [Slim Templates](http://slim-lang.com/) by default they are located in the `lib/views` folder.

###Zurb Foundation and Modernizr
I've included the default full [Zurb Foundation](https://github.com/zurb/foundation) style set and the basic javascript dependencies. In addition [Modernizr](http://modernizr.com/) and [Normalize.css](http://necolas.github.io/normalize.css/) is included as part of the Foundation build. Some important things to keep in mind:

- `lib/assets/stylesheets/_settings.scss` - Here are all the Zurb Foundation template settings, used these to customize your whole look in a flash.
- `lib/assets/stylesheets/app.scss` - Here is the main stylesheet for your app, you can trim down what you are importing from Zurb Foundation here.
- `lib/assets/javascripts/head.js` - This javascript is included before the `</head>` tag in your layout. Keep this to a minimum.
- `lib/assets/javascripts/tail.js` - This javascript is included before the  `</body>` tag in your layout. [jQuery](http://jquery.com/) and the Zurb Foundation javascript is included in this area as well.

###Asset Pack
All of the assets are managed with the [Sinatra Asset Pack](https://github.com/rstacruz/sinatra-assetpack) which is configured in the `lib/app/server.rb` file. Add additional assets or change the configuration here.

###Configuration
All of the Sinatra configuration settings can be controlled in the `lib/config/config.yml` file. This is included as part of the[Sinatra::ConfigFile](http://www.sinatrarb.com/contrib/config_file.html) plugin. You can also add in any of your own settings, included are a simple title and description property.

By default the production values are set and any of those you want to over ride in other environments can be easily specified in their respective sections.

###Testing (YOU BETTER BE DOING IT)
By default this boilerplate includes system tests, unit tests, and code quality tests.

####Code Quality
As part of the Guard watch and the rake task `rake quality` you can run the [Rubocop](https://github.com/bbatsov/rubocop) code quality checker which will throw crazy errors if your code is a mess. Fix these and everyone that interacts with your app will be happier.

####Unit Testing
An example and useful `version.rb` file is included to illustrate the unit testing. Simply create your classes under `lib/app` and the associated spec under `spec/unit/lib/app`. To make this easier you can use the [Blam](https://github.com/neverstopbuilding/blam) plugin to create your new class files. For example:

    blam --just-unit MyModule::MyClass

Will create the `lib/app/my_module/my_class.rb` and `spec/unit/lib/app/my_module/my_class_spec.rb` files with templates ready for tests and code. BLAM.

Run the unit tests with: `rake unit` which will also generate a code coverage report in the `build` directory.

####System Testing
There are also two example system tests: `spec/system/lib/app/server_spec.rb` and `spec/system/lib/views/index_spec.rb` that show both the [Capybarra](https://github.com/jnicklas/capybara) and the [Rack::Test](http://www.sinatrarb.com/testing.html) forms of testing your application on a system basis.

The end-to-end tests use the default headless html browser that comes with Capybarra, but feel free to hook it up to something like Selenium as you need.

Run the system tests with: `rake system`

You can run all of the testing and quality checks manually with: `rake build`

###Deployment
I built this to be effortless, here is how to deploy:

    git push heroku master

Done.

##Contributing
I built this because I was about to build a Sinatra app anyway and wanted to share a solid foundation. If you are doing the same, why not start with this, add anything I missed and send a pull request. Pretty soon this could be quite robust and show off the best practices.

Some things that could use improvement:

- HTML and Search optimization
- Better including of Zurb Javascript files (I shouldn't need to commit them.)
- Better asset compression/middleware caching and what not.
