# The Weather Project

### Flutter applicatin built with REST API from [OpenWeatherMap.org](https://openweathermap.org)

#### Features:

- Accurate weather report in seconds.
  
- Visual depiction of weather using a banner on top of the screen.
  
- One tap weather functionality to automatically retrieve weather data of place where the user is currently located.
  
- Clean Horizontal list of diferent flags depicting the countries where the selected location is set.
  
- A seperate list to let user easily modify his/her locations preferences.
  

#### Keep in mind:

- The sunrise and sunset details can be wrong due to varying timezones.
  
- A top warning symbol will appear if the device isn't connected to the internet.
  

#### Bugs Introduced:

- If the data in the list is modified, especially if the element on the top of the list is deleted, the main page will still show it untill any gesture is prompted, A refresh pull is given to reload the whole page to remove unwanted locations.

#### Features yet to be added:

- To keep the cache of the data if the connection goes offline.
  
- A stream listener to check weather stats in the current user area.
  
- A permanent notification for easy weather access.
