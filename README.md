# SCC-File-Renamer
![SCC-File-Renamer](http://joeflack.net/wp-content/uploads/2016/02/SCC-File-Renamer.png)

## About
SCC File Renamer is a script that will flip the order of 2 strings within the filenames of a batch of files, so long as the filenames are of the following syntax: 

String1 #### String2 - Suffixes

## Applications for Usage
I use this script at work on a weekly basis, for the purpose of keeping a sorting timesheets in order by either client/project or employee. Below is an example of an application of this filename syntax that is typically used in my current workplace, as well as how the filename would be converted.

ProjectA MMDD EmployeeD - Notes yada yada
->
EmployeeD MMDD ProjectA - Notes yada yada

This is very useful for renaming a large number of such files at once.

## Common Issues
* Windows does not allow Powershell scripts to be run by default, for security reasons. If you haven't already, make sure to [enable running of PS scripts](https://technet.microsoft.com/en-us/library/ee176961.aspx).
* Make sure that there are no spaces in the path with which you run the file from.

## How to Use
### Non-Windows Operating Systems
There do exist means with which to run Powershell scripts on non-Windows operating systems. Unfortunately I do not know the details, so I would be unable to support any such issues ;(.

### Windows
The script is written in Powershell. Windows 7 and later versions come with Powershell installed, but for prior versions of Windows, you will need to install it first.

First, you should clone this repository. Then you will need load powershell first and run the script manually. Optionally and even better, you can set your system's .ps1 files to open with Powershell by default. Doing this will allow you to run by double clicking.

Some sample files have been included. Feel free to run the script on these files to see it in action!
