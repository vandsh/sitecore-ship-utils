### What is it? ###
A couple of powershell scripts to aid in item delivery to servers

### What does it do? ###
Helps you upload, install, and publish `.update` files to a Sitecore instance from Powershell thru the `Sitecore.Ship` module: [https://github.com/kevinobee/Sitecore.Ship](https://github.com/kevinobee/Sitecore.Ship)

### What do I need it for? ###
I stumbled across the inital premise for these scripts somewhere online (they are not originally mine). I needed a way for a VSTS (TFS+RM) release to upload and trigger a publish of an update package.

### How do I use it ###
Should be as easy as:

1. Clone, download, whatever, just get these files into your project

1. Execute the scripts with the necessary params provided.

1. To install/deploy: `.\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\myCore.update" 300`

1. To publish: `.\publish-sitecorepackage.ps1 mysite.dev "preview,web" "smart" 60 300`

### A few advanced examples ###

1. To install/deploy to an endpoint that has Basic Auth and save the IDs of the items that get overwritten by the update: `.\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\1-mysite-templates.update" 300 -ResultsOutputPath "c:/temp/ids.txt"`

1. To publish only the list of IDs overwritten to an endpoint that has Basic Auth: `.\publish-sitecorepackage.ps1 mysite.dev "preview,web" "en" "listofitems" 300 MyUserName MyPassword "C:/temp/ids.txt""`