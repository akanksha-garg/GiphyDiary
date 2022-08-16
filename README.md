# GiphyDiary

## Author:- Akanksha Garg
email: <akanksha.garg9@gmail.com>

## Screenshots

![](GiphyDiary/Resources/GiphyDiaryScreens.png)

## Overview

Implemented in Swift and compatible for both iPhone and iPad (Different screen sizes.)

This project contains two tabs. 
  - First Tab: 
  Contains a search bar and a table view to display trending GIFs fetched from Giphy API.
  User would be able to add/remove a GIF to/from favorites list by pressing a favorite button. GIFs which are already added to favorites can also be distinguished easily. (filled Heart icon at top.)
  
  - Second Tab: 
  Contains a segment bar on top to switch the view between grid and list. By default the grid will be selected. Also, contains a collection view that Fetch and display the GIFs from the file storage that were made favorite in the First tab.User would be able to unlike any GIFs by pressing the favorite button.(filled Heart icon at top)

## Architecture

This project follows MVVM Architecture.
 - Model:  Simple data model objects.
 - View : Includes data related to UI of application like ViewControllers , Storyboards, XIbs.
 - ViewModel:  Contains the business logic for a particular use case and handles preparing content for the display.

The project is segregated into three main layers.
  - Domain: This is the core of our application. It contains Entities and ViewModels.
  - Presentation: It contains Views.
  - Application: It contains Models, Network Manager, Resources and Utils.

## Get Started

This project uses CocoaPods for dependency management. Please open the .xcworkspace in Xcode 13 or above. It should work right out of the box.
However, if you face any issue in building or running the project please run pod install command.

## Dependencies

  - This sample app require minimum iOS 15.2 and Xcode 13.2 to run.
  
## GIPHY API Integration
Giphy is an animated GIF search engine. The Giphy API implements a REST-like interface. Connections can be made with any HTTP enabled programming language. Following APIs are used in app to fetch the data:

  - For Fetching GIFs: api.giphy.com/v1/gifs/trending
  - For Searching GIFs: api.giphy.com/v1/gifs/search
  - Giphy documentation: "https://developers.giphy.com/docs/api"
  
  **Note: GIPHY requires developers to use a key to access API data. To use the GIPHY API, you'll need a (free) GIPHY account. Then, you can obtain a key. Please add key in Constants File (i.e at "giphyAPI_Key") file to successfully run the project.
