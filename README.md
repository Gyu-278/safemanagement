# SimpleLoginScreen
Simple Login Screen Project using Swift UI. <br/>
# Tutorial uploading XCode project on Github
[How properly upload Xcode projects on Github](http://irenebosque.com/how-to-xcode-and-github/)<br/>
[Writing Github README](https://medium.com/analytics-vidhya/writing-github-readme-e593f278a796)<br/>
[Basic Markdown syntaxes](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)<br/>
[Creating Links in Markdown](https://anvilproject.org/guides/content/creating-links)<br/>
[Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
# Some Xcode Swift UI basics
XCode->UI(user interface->publish app to App store->downloadable for users)<br/>
Create a new Xcode project->IOS->App<br/>
Setup project name/app name->Team as personal Apple ID->Organization name<br/>
<ins>Organization Bundle identifier</ins>(unique ID of your app)->swift->leave everything else<br/>
Unselected->create gitSource->create at a location<br/>
Close the sidebars on two sides<br/>
# Compatiability
iPhone 13,iPhone 12,iPhone 11
[# Content View](https://github.com/KrystalZhang612/SimpleLoginScreen/blob/main/ContentView1.png)
    NavigationView{
    ZStack…
    //design the overall background
    VStack
    //textfields 
    }
Attach the attributes all behind the scopes(colors, frames, sizes, etc.)<br/>
When it comes to user private info that need to be encrpted such as password, we use
`SecureField`
rather than using the regular
`TextField`to encrypt the user input into black bullet points. <br/>
`NavigationLink{}` allows us to redirect the authenticated and successfully logged in users to enter the user page, which is ShowingLoginScreen, allowing us to program the user login page. Append to set the navigationBarHidden to true to properly hide the navigation bar for better looking UI. <br/>
For the UI background to be more compatible occupying the entire screen. <br/>
Create the user authentication function after the navigation view. <br/>
In the authentification function, use 
    `lowercased(...)`
method to not have case sensitive<br/>
Then call the user authentication function in Button. 
# Run-Time Testing
Click the play button right next to preview on UI <br/>
Click the play button again to switch temporary testing off if want to go back programming. 
# Method Running The Project
Download the project to local directory<br/>
Xcode must be `13.4` and higher versions<br/>
Compatible with MacOS Monterey `12.0` and higher versions<br/>
# Initial Testing Result
Both username and password authenticated: [`screenshot 1.0`]()<br/>
Username is authenticated while password is not: [`screenshot 1.1`]() <br/>
Password is authenticated while username is not: [`screenshot 1.2`]() <br/>

