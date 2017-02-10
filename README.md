### What is it? ###
A couple of powershell scripts and a curl.exe

### What does it do? ###
Helps you upload, install, and publish `.update` files to a Sitecore instance from Powershell thru the `Sitecore.Ship` module: [https://github.com/kevinobee/Sitecore.Ship](https://github.com/kevinobee/Sitecore.Ship)

### What do I need it for? ###
I stumbled across the inital premise for these scripts somewhere online (they are not originally mine). I needed a way for a VSTS (TFS+RM) release to upload and trigger a publish of an update package.

### How do I use it ###
Should be as easy as:

1. Clone, download, whatever, just get these files into your project

1. Execute the scripts with the necessary params provided.

1. To install/deploy: `.\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\myCore.update" 60 300`

1. To publish: `.\publish-sitecorepackage.ps1 mysite.dev "preview,web" "smart" 60 300`