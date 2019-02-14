# xkcd-ios

This app uses MVVM instead of MVC. 
I have seen other implementations of MVVM but the way this project is setup has my own spin on it taking
others recommendations on it.


run the following comman after cloning project ( must have cocopods installed)
# pod install

<p>
Alamofire:
Used this library for making requests to the api.
Mainly used it because i can build a wrapper around it with swift 4s decodable protocol to facilitate making
requests and receive objects instead of json dictionaries.

KingFisher:
Used this library to load images from the internet into imageviews.
This is my first time hearing a library like this was out there, so I was convinced I had to use it (always welcome the chance to learn something new).
I have built my own way of loading images into imageviews but this is a more defined way of handling them.
</p>
