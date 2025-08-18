AUGUEST 16- 2025  -
Im able to get the trips data on GoMapView when i dont have the signin screen hooked up yet. Wtf.




AUGUEST some 2025  -

> On sign in and verify page, put the cursor on the input on page load. 

> Rider home google auto complete and rate api work.
> Make the map to show the map and how it shows the blue line like in Empower to work. 

Make site like intro.co 



HIGH -

-> Remove the demo login , after we get the aws phone texting working, its not working nor we should need it. 

> Make transition from go to add new clients make it simple and actually save in the backend. 

-----  -----  -----  

In DriverEdit js  page.  :::   
see and fix the following line for kashapp
style={[styles.input, zelleFocused && styles.inputFocused, { flex: 1 }]}
check this line for kashapp. 

2) remove  "cashApp" frmo everywhere in 


>  RiderDriverSelect -  this needs to send who user selected as Rider or Driver information to backend. 

-----  -----  -----  
RATECARD - I dont think ratecard is fully done,  So make sure its fully polished, like it get errors on front logs. 


needs to show saving animation when save buttn is hit 
also ive to hit it several times to make sure it saved the data.  wtf 
-----  -----  -----  

When you uploadin the imgage or saivn the profile update it needs to show the loading 
screen otherwise it creastes a mess when people do it fast. !!! 

Subscription -  if you dont subscribe yoru current locaiton wont be shown and you will be shown below the other drivers. 




Allow gig delivery workers to set their own rate cards etc. 

fix this : 
28-Error fetching route from backend
in RideRequestModal.js


===
How do you make sure that once trip is created, the app keeps on looking for drivers for like 10-15 minutes until the trip is cacnelled ? and in the 5th minute when driver enters nearby the locaion he gets the push notification ?




The same "getRouteCoordinates" are used to show on the map for multiople screens including hte  VConfmr and 
ride modal  so its wise save this somehwere , maybe in the db for that specific trip.  & from that trip ID  so it on the maps. 


Show "getRouteCoordinates" polygon for vconfirm and similar screens. 



This code needs to be updated on RideRequestModal :

 <Text style={styles.time}>5 mins (1.2 mi) away</Text>
              <Text style={styles.location}>{pickupLocation || 'Unknown Pickup Location'}</Text>
              <Text style={styles.time}>4 mins (1.4 mi) trip</Text>


> if airport there is additional fee 
https://youtu.be/z0zIYoTeRMA?t=542


> Let rider the ability to add a stop in the begining and in the middle fo the ride. 

> update pricing if the ridetype is diff based on imessages pics. 



> if the stop sign is added, youhve to calculate the time and dollars $$$. 

> when driver have accepted the ride and he is going towards it , if the rider cancelled it , it should show the screen or sound to the driver along with the sound music. 


> On arriving to chooseride it needs to make sure that the price is updated. many time it doesnt. 

> eta: '3:59 AM', duration: '13 min away' to be coming from backend 

> let riders add a stop. 

> // fix if the fetch user is not working, try this: then send them to signin screen ?
for this function -  export const fetchUser = async () => {

  
  > push notification > before the modal is sent , ensure the user is logged in 
  and also make sure if the driver is only online or not otherwise.



> Let drivers add a rider via the go screen ?

> the rides should only be added to trip advisor thing, if the driver is close by so fix that.  Also before that capture the drivers location in teh mongo. 

> In trip plan maybe call the backend for google auto suggestions. to fix that bug. 


> in this rideplan code, it should automatically select the current location , but user shoudl be able to change the location by clikcing the cross icon on the right . and 2) once i have selected from the drop down it needs to stop showing the google' s auto suggest for places. 3) same goes with pickup location once i have input the address the auto complete should stop appearing. heres the current code tell me where do make changes :


> CALCUALATE WIHT THE RATE CARD AND GENERATE THE PRICE DYNAMICALLY...


> When user hits cancel on V_Arrived.js  it shoudl trigger backend to cancel the ride request and then it shoudl start looking for another driver. 

> Show   MapView with to from address  on the chooose a ride screen. 


> maybe show map on V_Arrive screen. 

IMP ->
> IN rider screens , it needs to use zustang to pass the values of to and from and 
also show the map on teh screens, which requires calling GeocodeAddress in backend code to geneate the maps polygon. 


> The navigation from one screen to other needs to be more smoother. 


> When user signsup we need his name. Even the rider or whatever. 


> in chooose a ride screen when user hasn't selected a ride,  send them red notification that theyve to choose the ride first or 
mae the choose button NOT highlight or not clickalbe untl one has selected. 


> Toll integration - using google api does it tell me when on the path from one place to another there is a toll ?



> in createTrip functinon   also send user info like his/her name, phone number to backend.
// Fix - before you create a trip youve to calculate pricing 


> The app isnt sounding the trip sound even when its not actively open in front of you.  This needs to chagne like Empower will ring me even when i dont hvae the app open. 


> as a rideshare app we need to keep the log of times teh user is online and offline, how do i save this info in the backend with backend code ?




problem: is settings screen its pushign / patchign the expo's token 
& its also doing the similar thing in App.js 

useEffect(() => {
  const setupNotifications = async () => {
    try {
      addDebugLog('Starting setupNotifications');
      const pushToken = await registerForPushNotificationsAsync();
      if (pushToken) {
        setExpoPushToken(pushToken);
        addDebugLog(`Expo Push Token: ${pushToken}`);
        try {

====

Allow users to invite on testflight using the link. 


go to this link 
https://appstoreconnect.apple.com/teams/2092f43d-e3cc-4299-987a-0fb01a64b14b/apps/6745809453/testflight/groups/2c4a2446-33c3-4686-91b5-521eb120d629

	1.	Under Testers, go to the External Testing section.
	2.	Click on the tester group (example: BT – beta testers).
	3.	You should now see a section that says Public Link.
	4.	Click “Enable Public Link”.
	5.	After enabling, you’ll get a URL — copy it and share it with anyone.

---- 

upon clicking back from home rider screen it goes to go screen when it shoudl stick with the rider stack screen. not go to other stack. 

Trip -  When a trip is created, it shoudl send push notification to 
the ( nearest) drivers. 

> Also keep saving the driver's location all the times. 

> Take permission of location when needed. 

> Implement navigation the right way like created in another folder. 

> when rider input the request to and from , it should generate push notification to drivers based on its location. 


when app is crashed, it should be opened to the same screen as before, if token is not there, it goes to the signin and then comes back to teh same screen,  in order to implement this do i need to save current nav link in async storge or what ?


> once i swipe to the second trip and then the subsequent maps pan at the right position but for the first route , it he map's position is broken. 


======== ======== ======== ======== ======== 
GO SCREEN START 



> IMP-  Put the driver/ rider selection in profile update screen, 
the UI is ready but not working, fix that ( shoudl be easy).

>  If user tries to change the mode from drive to offline but he is saved as Rider , 
Alert him to chnage that settings in profile edit... 

> Fix how trip radar show up, it should be more fancy. 

> I think upon entering this screen, it shoudl retrive the fresh data from backend. 
> Also use the global loading view  that can be used in other screens as well. 
GO SCREEN END
======== ======== ======== ======== ======== 



In the app image also show :  not in your network driver, use somethign like let me try this new guy.... 
95% females appve of him. 

Show a divider line saying not in ur network yet!!! 

> Apply for EIN number - setup the company : You can apply for an EIN without registering a company, 

Then create the brand
https://portal.telnyx.com/#/messaging-10dlc/brands


MID  - 
====== ====== ====== ====== ====== 
fix this in ratecard 
 // Handle contact actions
  const handleCallSupport = () => {
    Linking.openURL('tel:+1234567890');
    setContactModalVisible(false);
  };

  ====== ====== ====== ====== ====== 

> Add analytics from google firebase. 


> Account deletion workign but not navigating to the login screen. 


> Maybe on stops screen show the pickup and destination address also. 

Remove this screen : RideIncoming & FontsScreen

> In Vconfirm screen show the blue lines that change as Driver nears the Rider. 

> on Vconfirm screen's cancel button  it needs to calcualt the time from its arivaal , not when it clicks teh cancel button. 


in go screen when they decline the trip it should be removed for that guy. 
if Accepted, move to next screen. 



when i change my name in my profile edit screen it dont reflect that on navigation menu immidiately we need to call the refresh to zustang or soemthing more so it works perfect. 

On otp screen make the function of go back and Resend otp. 



Shared driver list : 
What if teh user said ok let em try ur list of driver but i am not 100% sold, so platform should let user to filter / delete those drivers. 



> on prod and on expo go even when i hvae updated the ref code to new value it keeps
showing me old value, even whn the db has new value.  WTF 

So the problem is when user goes to referal screen it doesnt request the fresh values 
from the backend. 


> once the person is logged in, his info shoudl pop up on edit profile screen , its not  & its BS  wtf. 

> refer screen freezes when it fails to chnage referal code. 


Security - if you want to check the rider or driver, ask can you please confirm the pin code ?


> once we hit login button on signin and signup screen, itshoudl 
show laoding screen otherwise it looks weird like nothing happneing. 


> if the messagse is token invalid or token expired, it should direct user to signin page. 

> Persist navigation : gpt ok now what do we do so that even whne the app crashes by the user , it should save the screen or page its at and open the same page again ?  in otherwords how do i  Persist Navigation State ?



========

> Ask drivers for their Schedule so you can match their favorite riders.


> How can i have all screens taking the full screen and the menu / hamburger button comes on top left in case user wants to click it, but it dont take over the screen until clicked. 



Driver profile info shoudl be dual , i.e when the page loads it should already 
have that info loaded on it. 
create /me function on backend.



> Not able to create or view exisitng posts from that user jay@me.com / pass  on Phone simulator. 


> Use this sexy image on signup.
like austinride or rideaustin github
https://github.com/ride-austin/ios-rider


> Be sure if you wanna have the toekn with Asynch of with zustang, also make sure it stays thre after phone crashes or its restarted, which one keeps there ?
gpt: how to  Recovery after restart: At app start, Zustand (with persist) will automatically: •	Rehydrate from AsyncStorage. •	Give you access to the user and isLoggedIn right away. •	No manual token fetching needed.

 ======= 
Merge the apis code to this one

Allow users to Edit/ modify their referal codes. 
ref=CHRISTOPHER05228

Finish the incoming request page! 




You can do everythign in one app - We Chat 

https://www.youtube.com/watch?v=j3OOS-3oU8k


=======
Ayden payments 
https://www.brex.com/ ?

======

google maps api key - AIzaSyAwGTDcruBxsCiiUWHoNHGuzHeciIfsFmw

use this webstyle for QR code : https://upside.app.link/HARRY3953

> Record the tiem that rider maek the driver to wait every time, do the average or whatever so driver knows this Rider  is good. 

> Same as above , show some thign to the drivers if this rider tips or not. 
> How fast is the stops. 










LATER - 
Ride end page - make the tip option to be picker option. 

> On rider first page, give user the option to click LATER calendar. 

> Implement REDIS

> the swiper thing on v_confirm and similar screen is not best experience.
> in v_confirm fix teh cancel and other button options.
> DO not let user navigate out of v arrived , v confirm & dropoff screen bc if you let him navigate out 1) driver will start playing with his phone , distracted on new trips etc 
and he will forget to swipe on drop off at the end of the trip. 




icons 

get icons from here 
https://www.flaticon.com/search?word=car

