# Weather_Swift

**Weather_Swift**  app shows live weather data fetched from [MetaWeather](https://www.metaweather.com/api/)

The app consists of a single screen, showing pre-configured number of cities whose weather data is fetched from the API for the next day.

Locations can be preconfigured form [Locations.json](https://github.com/PriyankaNBandaru/Weather_Swift/blob/main/Weather_Swift/Locations.json)

Weather API data is fetched on the launch of the application and also fetched every 3 minutes to retrieve the latest information.The api is fetched every 3 minutes and the last updated label at the bottom of view is uupdated accordingly.

# App Architecture Overview:

The app uses MVC architecture.

## Models

Both the models **Location** and **LocationWeather** implement NSObject thus handling data

## View

The view Controller does the data representation 

## Controller

The Controller with the help of the methods from **APIHelper**,**JSONHelper**,**Helper** receives the data and sends it to the View and explains how to use the data.

# Unit Tests:

`Weather_SwiftTests` target contains unit testcases for JSON to Model conversions,file to json conversion,URL generation.

# UI Tests:

`Weather_SwiftUITets` target contains UI test cases to test the existence of labels,images on swipe and on load.

# Utilities:

The Utilities consists of **Constants.swift** file that includes the different constant values used within the project.

# UI:

The view for the app is contained within storyboard and is handled by  [ViewController.swift].The view updates on a swipe to right/left and displays the Weather for respective cities.

The view is drawn using the auto loayout constraints set in the storyboard.


# Limitations:

The background images can be animated with the help of UIAnimation.

The timer time can be passes dynamically by setting it in Info.plist file.






