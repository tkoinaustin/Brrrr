# Brrrr

## About the App
Brrrr is a weather app using the Dark Sky public API for weather information. I built it to distribute on the App store as an example of my coding style. Unfortunately, Apple didn't see eye to eye with me and so far has refused to accept the app. That is too bad, I really like the app. It is modeled on the built in Apple weather app because I liked the interface.

## About the code
I use SwiftyJSON and PromiseKit, both of these pods are used regularly in my projects. They add value without being overly bloated. Well, PromiseKit is a handfull, but for asynchronous calls it can really be worth it. My project structure typically consists of an API folder for accessing data, Models for holding on to the data, ViewControllers for, well, view controllers, and Views for anything reusable, like table cells or specialty views. 

I typically use a one storyboard per view controller model. While I like seeing the big picture you get when all the scenes are in one storyboard view, there are major issues when working in a collaborative environment. Additionally, With a storyboard instead of a XIB, you can sometimes leverage the segues to make the code cleaner and simpler.

Most mobile apps need data and it usually comes from a REST service API. This program shows one method of accessing that kind of data and using it in a mobile app. 

## Installation

Clone the project using the 'Clone or Download' link

## Dependencies

You will need Cocoapods install on your development computer, see: [Cocoapods](https://cocoapods.org)

Then run the usual 'pod install' to install the required modules. You need to close the project and open the workspace from now on.

## Watch your language!

I use SwiftLint to enforce good hygene. If you do not have SwiftLint installed it skips the check. To get SwiftLint go [here](https://github.com/realm/SwiftLint) and follow the instructions.

## Updating the Dark Sky API Key

Follow the instructions to obtain your free API key [here](https://darksky.net/dev/register)

### Then, in your project directory:

* Open 'Brrrr/APIinfo.plist'

* Open and edit the file, add your key value to the DarkSkyAPIKey entry under Root

* You'll want to exclude updates to this file from git so you don't accidentally upload your secret into your repo:

~~~~
git update-index --assume-unchanged Brrrr/APIinfo.plist
~~~~
* You should never see APIinfo.plist when you 'git status' to see changes, if you do, STOP, something went wrong.
