# wagChallengeProject

Coding Challenge iOS Project

Created a stand-alone app that retreived data from the following site:

[Stack Exchange](https://api.stackexchange.com/2.2/users?site=stackoverflow)

Requirements included the following:
1) Display retreived data as a TableView.
2) Display the following data: username, badges, and gavatar from the list.
3) While loading the gravatar, UI should show a loading animation.
4) Each photo should be downloaded only once and stored for offline use.
5) UI should be responsive.

Language: Objective-C
Version Support: ioS 10 and up

No third party libraries were used in the app.

Coding Separated into 5 groups
1) Services
   HTTPService where the connection is created to retrieve data
2) Model
   UserData, where username, profile image, badges are organized
3) Storyboards
   Main ; Only 1 storyboard was created for this project since only 1 view controller was needed
4) View
   DataTableViewCell ; Information regarding the custom table view cell information is altered here
5) Controllers
   DataViewVC ; 1 view controller with a tableview
