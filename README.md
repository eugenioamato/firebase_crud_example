# FIREBASE CRUD+E+L OPERATIONS on FLUTTER WEB and MOBILE


![allscreens](/screenshots/allscreens.png)

Complete guide for CRUD+E+L firebase operations in Flutter (mobile/web)

## Specs

This project was created with the following specs:
>  android studio 4.1.1   
>  Flutter 2.2.1 • channel stable • https://github.com/flutter/flutter.git
>  Framework • revision 02c026b03c
>  Engine • revision 0fdb562ac8
>  Tools • Dart 2.13.1
>  Node version v16.3.0
>  npm version v7.15.1
>  firebase version v9.12.1
>  macOs version 11.4 (20F71)
 
  


### Create a new Firebase project

If you still have no account on Firebase, create one on  
>https://console.firebase.google.com/  

Create a new project. The name is just a label, but for this project use `firebase-crud-example`

![createproject](/screenshots/creaprogetto1.png)

Note that the Project-Id is created here. You can customize the Project-Id choosing a new one editing it with a click on the pencil icon.
You cannot edit it after the project is created, so try to find a better one (from the ones available) before going on.
Indeed, Firebase will create a web hosting for your app, that will be accessible at  
>https://[Project-Id].web.app  

and  

>https://[Project-Id].firebaseapp.com  

You DON'T need to enable Google Analytics for this project.  

Every time you create a project on Firebase, you are actually also creating a project into  
>https://console.cloud.google.com/  

Subscribe to it, and don't worry about inserting your credit card, the system will not charge you anything until you manually upgrade to a paid services.  

### Create an Android App  
![createandroid](/screenshots/creaandroid.png)

Click on the Android icon to make a new entry for the app we will create here.


![androidappregister](/screenshots/androidappregister.png)
  
  
###### The applicationId of your Android project
insert here  
>com.[yourCustomDomain].firebase_crud_example  
  
Note that in your future projects you should replace my id (example) with your own custom company or personal name.  
Note that you NEED to change this name in all these files:  
```
Android/app/build.gradle
Android/app/scr/Main/kotlin/com/[yourCustomDomain]/firebase_crud_example/MainActivity.kt
Android/app/src/Main/AndroidManifest.xml
Android/app/src/Debug/AndroidManifest.xml
Android/app/src/Profile/AndroidManifest.xml
```
    
###### A label to this android app  
  
###### Your Sha-1 debug signature  
This signature comes from your machine and will always be the same, no matter what project you are working in.  
To retrieve your SHA-1 debug signature, open a terminal and use this command:  

MacOs:  
>keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore  

Windows:  
>keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore  

The requested password is always 
>android

## Download the config file  


![downloadservices](/screenshots/downloadservices.png)

Save the google-services.json file in a secure place (NOT ON YOUR DESKTOP). You will need to insert a copy of this file into  
>Android/App  

Remember that this file should NEVER be included in a Repository, because it allows other people to access sensitive data connected to your personal Firebase account.  
When sharing this project to a trusted collaborator, you should send it in a separate and secure way.  

## Check that the dependencies are set  

Your build.gradle file should have these rows to work correctly:

```buildscript {
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
  }
  dependencies {
    ...
    // Add this line
    classpath 'com.google.gms:google-services:4.3.5'
  }
}

allprojects {
  ...
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
    ...
  }
}
```

Your App/build.gradle should also have these rows:

```apply plugin: 'com.android.application'
// Add this line
apply plugin: 'com.google.gms.google-services'

dependencies {
  // Import the Firebase BoM
   implementation platform('com.google.firebase:firebase-bom:26.6.0')

  // Add the dependencies for the desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}
```

# Activate your Google API
The app is now able to compile correctly, showing the app UI.


![homepage](/screenshots/homepage.png)

HOWEVER, the API from Google must be activated before your app can make requests to the Firebase Cloud.  

Trying to click on any of the buttons, or to make any CRUD+E+L operation on the database, will show an error:  


>W/Firestore(15045): (22.0.2) [WatchStream]: (8f993a7) Stream closed with status: Status{code=PERMISSION_DENIED, description=Cloud Firestore API has not been used in project [YOUR-PROJECT-ID] before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID] then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., cause=null}.
>W/Firestore(15045): (22.0.2) [OnlineStateTracker]: Could not reach Cloud Firestore backend. Connection failed 1 times. Most recent error: Status{code=PERMISSION_DENIED, description=Cloud Firestore API has not been used in project [YOUR-PROJECT-ID] before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID] then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., cause=null}

Note that the error show a specific web page that should be reached out to solve this issue.
`...Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID]...`

The Link provided in the error log is clickable if you are using Android Studio.   
Just click it to go to the Google Cloud Api authorization page, and enable the key that was automatically created.

![enableapi](/screenshots/enableapi.png)

You can, alternatively, reach the Google console at  
https://console.developers.google.com/apis/dashboard
  
Then select the project from the dropdown list on the top of the page  
Then enable the Firebase API  


# Create the Database

The app is still not ready!
Trying to click the buttons, or to make any Database operation will give an error:  
>W/Firestore(16270): (22.0.2) [WatchStream]: (6f16a3d) Stream closed with status: Status{code=NOT_FOUND, description=The project fir-crud-example-42f94 does not exist or it does not contain an active Cloud Datastore or Cloud Firestore database. Please visit http://console.cloud.google.com to create a project or https://console.cloud.google.com/datastore/setup?project=[your-applicationId] to add a Cloud Datastore or Cloud Firestore database. Note that Cloud Datastore or Cloud Firestore always have an associated App Engine app and this app must not be disabled., cause=null}.
>W/Firestore(16270): (22.0.2) [OnlineStateTracker]: Could not reach Cloud Firestore backend. Connection failed 1 times. Most recent error: Status{code=NOT_FOUND, description=The project fir-crud-example-42f94 does not exist or it does not contain an active Cloud Datastore or Cloud Firestore database. Please visit http://console.cloud.google.com to create a project or https://console.cloud.google.com/datastore/setup?project=[your-applicationId] to add a Cloud Datastore or Cloud Firestore database. Note that Cloud Datastore or Cloud Firestore always have an associated App Engine app and this app must not be disabled., cause=null}

We need to activate the datastore. Let's open again our firebase console, and select the second tab on the left panel, named "Cloud Firestore".
On the next page, click "Create Database"

![createdb](/screenshots/creadatabase.png)

Select now "TEST MODE" to allow permission to write to everyone.
Normally the project will need a permission level to avoid everyone to read and write your data.
But for this project, we did not implement any authority system. And the data is not sensitive.
  
Select the location of your data, based on where your customers will mostly be located. (I select eur-3 because I live in Europe)  
  
Click now on Create Collection, and name it  
>users  

For this project, we have choosen to give the main Document the ID
>testusers  

You don't need to specify the fields. 
Creating the fields now will simply add the first record to the document. 
We don't need to create a first record for this project. Indeed, the Firebase Firestore is a No-SQL database, hence it is not a Relational Database. The documents can be different from each other, and we must not respect any scheme.
The Firebase Firestore is structured on a large JSON tree. Better remember this, because it means that every stored data is actually saved as a STRING.

# The app is finally working!

You can now run the example in your favorite IDE, connected to an Android Emulator or to a physical device.  
Having on the same screen your database console you can appreciate the data updating in real time. 


![datainserted](/screenshots/datainserted.png)  
Note that you can manually make all operations manually on the database.  
This allows you to control all your data without using any software. You only need a browser (and your credentials).  

# Operations: CRUD + E + L  
  
C : Create  
R : Read  
U : Update  
D : Delete  
E : Exists  
L : Listen  
  
All the operations are sorrounded by a try/catch clause to verify connectivity.  
Indeed, the firebase plugins don't send a catchable error when the connectivity is lost, because the offline database is actually used in that case.   
The listener, when no connectivity is found, will return the last state of the listened folder.  

## Initialize Firestore

  
In the mobile version, the code is launched in the first `initState` of the first view, through the `cloud_firestore` plugin
``` 
await initializeApp();
fsi= FirebaseFirestore.instance;
```
  

In the web version, the Initialization is made inside the file `index.html` , and the instance is retrieved through `firebase/firestore.dart`, in the plugin `firebase`   
```
fsi = firestore();
```
  

## Exist operation  
The exist operation is activated by the other methods, to avoid double writings or unchecked errors.
> return (await fsi.collection(s).doc(t).get()).exists;
  

## Create the record
Try to click the "CREATE" button on the app. 
>return await fsi.collection(s).doc(t).set(map);

The _create method checks first if the record exists (stopping with an error in that case), otherwise he sets data from a json map:  
```
  void _create() {
    _dataRepository.createData(
      'users',
      'testUser',
      <String, dynamic>{
        'firstName': 'Sandro',
        'lastName': 'Manzoni',
      },
      'Record written Successfully',
      'ERROR ON CREATE: THE RECORD ALREADY EXISTS',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }

```

  
## Read the record  
Click on the "READ" button.
>return (await fsi.collection(s).doc(t).get()).data();  

The method tries to read data and transforms the resulting unordered map in a `SplayTreeMap` (automatically ordered with binary search).
If the data doesn't exist, this will result in `null`  

```
  void _read() async {
    _dataRepository.readData(
      'users',
      'testUser',
      'Data found',
      'ERROR ON READ, THE RECORD WAS NOT FOUND',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }
```


## Delete the record  
Click on the "DELETE" button.  
>fsi.collection(s).doc(t).delete();  

The _delete method checks first if the record exists (returning an error if it doesn't), otherwise it deletes all the document.  

The exist check is necessary, because Firebase doesn't give an error when trying to delete something that doesn't exist.  

```
void _delete() async {
    _dataRepository.deleteData(
      'users',
      'testUser',
      'Record deleted Successfully!',
      'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }
```


## Update the record  
Click on the "UPDATE" button.  
>return fsi.collection(s).doc(t).update(data: map);
  
The _update method is different from the _create, because it will attempt to write only a record that is already there, throwing an error if it is not found. Catching the error can return a string representing the problem that occurred.
```
void _update() async {
    _dataRepository.updateData(
      'users',
      'testUser',
      {
        'firstName': 'Alessandro',
      },
      'Record updated Successfully! The name is changed to Alessandro',
      'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }
```
 
# Listen operation

Every time the database folder "users" is changed (by us, by another user writing to the same folder, or by the administrator doing operations through the Firebase Console) we want to receive a message, and update the UI. This can be done registering a StreamSubscription when the app starts.  
This command will return a StreamSubscription, for a stream that contains pairs (Id,Data) . The id is a String that represents the name of the document, and the data is a Map containing key-values of every information contained in the document.


```
listen(String s,callback) {
     return fsi.collection(s).snapshots().listen((QuerySnapshot qs){
       callback(qs.docs.map((QueryDocumentSnapshot ss)=> [ss.id,ss.data()]
       ));

     });
  }
```
  
The callback is a method containing your logic. In this example, we will simply place a String representation of all documents at the bottom of the app.  
In the event of an empty answer from the listener, we show a SnackBar with an error. We expect the user to exit the app and retry later.  
If the connectivity is gained in a second moment, we dismiss the SnackBar.  

```
  void manageEvent(events) {
    if (waitingForFirstConnection) {
      if (events.toString() == '()') {
        showErrorSnackbar('No Internet connection!', false);
        errorInConnectivity = true;
      } else {
        if (errorInConnectivity) {
          errorInConnectivity = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        waitingForFirstConnection = false;
        Helper.stopLoading(refresh);
      }
    }
    _dbMessages.clear();
    _dbMessages.addAll(events);
    refresh();
  }
```


It's important to remember that this subscription must be cancel() when we want to stop receiving updates.  
Canceling the subscription may happen when we logout, or when the app is closed, in his dispose() method.

```
  dispose() {
    listener.cancel();
    super.dispose();
    
  }
```
  
# Is the project working on WearOs?
  
WearOs can be considered a normal Android application. The only thing to care about, is that the screen is very small. But using the Auto-Size-Text plugin, everything can be read properly.
Also, I have added the visibility_detector plugin to check if the error/success message is visible when a message is printed. If it is not visible, the ListView will be animated to the top to allow the correct behaviour of the app also on WearOs. 
Everything else is working as expected, and we don't need any other management because the Android configuration applies to WearOs without problems.
  

# Is the project working on ios?  

*Note that you will need a Mac to compile the project for iOs*

The flutter app contained inside our /lib folder is ready to be compiled for iPhone.  
Adapting it for iOs, however, demanded some patience: 
The pod system is very odd. To make everything work I had to:  

Create a IOS project inside Firebase console, in a similar way to what I did for the Android app  

![iosdata](/screenshots/iosdata.png)


..save the config file in ios/Runner/Google-Service-Info.plist 


![downloadplist](/screenshots/downloadplist.png)


change the CFBundleName in the Info.plist file to match the one inside the plist  

Sign the app with my apple developer license  
  
I had to deep clean the project multiple times with:  
`pods install -repo-update`  

change the second line of ios/Podfile to 
>platform :ios, '10.0'  

(Apparently, firebase requires it)

If you enabled the Analytics, remember to add it in the pods file:  
>pod 'GoogleAnalytics'


The result is faster and smoother than the Android version.   

![iosscreen](/screenshots/iosscreen.png)


# Let's try Flutter-Web
  
## Implementing Flutter-Web
  
*The plugin cloud_firestore has a bug. It tries to request data to Firebase before initializeApp, and the error happens during the registration of the plugin.
So, the only way I found to make it work properly on Flutter-Web is to remove the cloud_firestore, and use the same commands found inside the plugin Firebase.
This forces us to comment out the plugin in pubspec.yaml before working with web plugins.  *
Inside pubspec.yaml, comment out this line adding an '#' before it:  
`  #cloud_firestore: ^2.2.2`
  
and run
`flutter pub get`

*REMEMBER that you will have to un-comment the same line every time you want to compile the project to mobile.  
Indeed, also the firebase plugin is not usable inside mobile application, because it uses html methods
*



Select now a different device for your build: Chrome  
Run the project with the green PLAY button on Android Studio, or with the terminal command:  
>flutter run -d chrome

Running the project, however, will lead to a blank page for now.  
Remember that you can always inspect the errors on a chrome page clicking 
> View > Developer > Developer Tools  

and selecting the "Console" tab

The error may seem confusing:  
>Failed to load module script: The server responded with a non-JavaScript MIME type of "text/html". Strict MIME type checking is enforced for module scripts per HTML spec.
>firebase-app.js:1 Uncaught (in promise) FirebaseError: Firebase: No Firebase App '[DEFAULT]' has been created - call Firebase App.initializeApp() (app/no-app).

Indeed, we called the initializeApp command at some point in the html file. Let's have a look at it. In your IDE, access the file:  
>web/index.html  

This file is the entry point of your Web-App. It only loads a Javascript file that is compiled by Flutter after the command `flutter build web`  


However, we note this line:  
`<script type="module" src="./firebase-config.js"></script>`

This file is not included in the repository. Exactly like the google-services.json file, it contains sensitive data on your personal access to your Firebase account, and thus should NEVER be included in a repository.

This data cannot be input manually. We must request to Firebase to create a web-app. Indeed, the configuration we already have was created for an Android App, and this is a totally different thing.  

# Let's create a new Web-App inside the Firebase Console.  

Go to the Overview page on your project and select "Add an App"
  
![addapp](/screenshots/addapp.png)

Click on the quote icon to create a Web App  

![webapp](/screenshots/webapp.png)
  
Register the web app with any label you prefer.
Tick the "Create a hosting" options to have a free hosting for your Web App, to be used later.
Note that the name of the app (and the address you will be able to reach it) is decided upon the applicationId, but that you can also try to find a better one (from the available ones), and that there is no rush. You can specify a different address later.  

The next page tells you what to add to the project to make it work with firebase.  
### Note that these specs are alreay inserted in this repository.  

You will need these lines into your HEAD section of the index.html  
to import the configuration and initialize the app, with the analytics (only if needed)  

  ```<script type="module" src="./firebase-config.js"></script>

  <script type="module">
  import { firebaseConfig } from './firebase-config.js';
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
  </script>
  ```
  
You will also need in your BODY section the following imports:  
  
>  <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-app.js"></script>  
>  <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-firestore.js"></script>  
>  <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-analytics.js"></script>  

Remember that, in case your app requires other libraries, you can find them on this website:  
>https://firebase.google.com/docs/web/setup#available-libraries  

under "Available Firebase JS SDKs (from the CDN)"  


## Install npm and firebase-tools

npm is the Node Package Manager . If you haven't it, you won't be able to continue. 
Check the NPM website for more information on how to install it on your operative system.
https://www.npmjs.com/get-npm

After, install the Firebase Tools, needed to use commands from your terminal.  

`npm install -g firebase-tools`
  
# Retrieve the web-configuration

In your Firebase console, open the Overview page and select the app.  
  
  
![selectapp](/screenshots/selectapp.png)

Select the web app.  
  
  
![selectwebapp](/screenshots/selectwebapp.png)
  
  
Click on the "Configuration" radio button on the right.  

![selectconfig](/screenshots/selectconfig.png)

Here you can see the configuration. 

![getconfig](/screenshots/getconfig.png)

You can save this information copy-pasting it. However, you must know that this data may be wrong. The best way to retrieve the correct configuration uses the famous firebase-tools  
  
# Let's start using the firebase-tools
  
  
>firebase login
  
you need to login within the webpage that opens up and authorize the firebase CLI


(If you get an error with all the next commands, 
check that your file `/.firebaserc` contains the correct projectId)

run in terminal:  
>firebase init

move your cursor on "hosting" , press SPACEBAR, then press ENTER

when asked "What do you want to use as your public directory?"  answer
>build/web

(This is the folder where Flutter puts the web app after production)  

when asked "(rewrite all urls to /index.html)" answer n  
when asked "Set up automatic builds and deploys with GitHub? " answer n  
when asked "File build/web/index.html already exists.overwrite?" answer n  

Now run in terminal:  
>firebase use --add
  
Select your app and press enter.
Choose an alias (whatever you prefer)


### Now you can retrieve the configuration.

run in terminal 


>firebase apps:sdkconfig
  
  
Select the web app and press enter.

Create a file inside your project in the folder web (same folder as index.html) and insert the data adding the `export var ` specification and removing the surplus parentheses:  

```
export var firebaseConfig = {
        apiKey: "AIza%%%%%%%%%%%%%%%%%%%%%%%%%%%%m8Vg4",
        authDomain: "fir-crud-example-%%%%%.firebaseapp.com",
        projectId: "fir-crud-example-%%%%%",
        storageBucket: "fir-crud-example-%%%%%.appspot.com",
        messagingSenderId: "12%%%%%%%7",
        appId: "1:12%%%%%%%7:web:b%%%%%%%%%%%%%%%%%%%%e",
        measurementId: "G-J%%%%%%%%%%E"
      };
```

Sometimes the measurementId may be missing. Don't worry, it is only needed if you requested the Analytics features. However, lacking to insert it will lead to a Warning on your web-page.

# The web app finally works! 

Run the project with the green PLAY button on Android Studio, or with the terminal command:  
>flutter run -d chrome


## Build and deploy to Web as a PWA

*Remember that the version uploaded to your hosting is the RELEASE version, not the debug or profile ones.*  
*So, it's always a good practice to build and test the app in Release mode before deploy.*

enter this commands in a terminal under your project root, but only if you already have completed the login-init procedure described above.  


>flutter build web
  
>firebase deploy

The terminal will print 2 links. One for the relative configuration page, and one for the actual address of the published web app.
Your app is now published, and you can share it the public, redirect a domain to it, and brag about it.  

![fullapp](/screenshots/fullapp.png)

You will also note that the browser will propose you to install this web service.  

![pwa](/screenshots/pwa.png)

What does it mean?  
The apps made with Flutter are single-page web services that respect the Progressive Web App policies.  
An agreement between most browsers allow those pages (PWA) to be installed on the user's desktop.
The icon that will be created will be very similar to an app.  
Remember, however, that it is NOT an app. Clicking on the icon will open a full page browser tab opening the flutter-web version.




# How can I force browsers to load the new version?

Yes. The browsers are evil. If you use always the same names for files, even when you upload a new version, the users will still have the OLD version cached. And the browser will ignore totally what you did in the new version.
But here's a trick you can use to force browsers to dump the old version:
In index.html the line  
` <script src="main.dart.js" type="application/javascript"></script>`
  
can be edited without breaking the app, adding a fake prop to the call in this way:  
` <script src="main.dart.js?version=1.0.13+1" type="application/javascript"></script>`

So, everytime you upload a new version of your web app, you should go up by 1 in this line, and, for coherence, in the third line of your pubspec.yaml  
`version: 1.0.13+1`. (not mandatory)  
  
This will force the evil browsers to reload the entire app.  
Doing so, (BEFORE `flutter build web`) you can be 100% sure that the client is not using an outdated version.  

# Conditional imports

In the Data repository (data_repository.dart) you can see this strange import:  

```
import '../services/db_interface_stub.dart'
    if (dart.library.io) '../services/database_interface.dart'
    if (dart.library.html) '../services/web_database_interface.dart';

```  
  
The compiler will understand that we are compiling the project to Web because he will find the html library.  
But, remember what we said before? The app cannot be compiled for Web if we have the cloud_firestore plugin loaded. 
So what happens when we remove that plugin (commenting it with '#' and running `flutter pub get` ?
The Android Studio IDE is unable to understand that we are going to work only for web, and our Dart Analysis will show a lot of errors. 

  
![stuberrors](/screenshots/stuberrors.png)
  
Why is that? In the file `web_database_interface.dart` we are still importing the cloud_firestore plugin, and even if we know that that file will not be compiled, the IDE is complaining for missing files and unknown methods.  

  
Very annoying isn't it?
Also because the project can be compiled and run without any problem.  
So I had the idea to insert another conditional import inside the database_interface.dart  
```

import 'firestore_stub.dart'
if (dart.library.io)
'package:cloud_firestore/cloud_firestore.dart'
;

```  

and a lovely fake file (that will never be compiled) that I call a *stub*  
```
class FirebaseFirestore {
  static FirebaseFirestore instance;
  collection(String s) {}
}
class QuerySnapshot {
  var docs;
}
class QueryDocumentSnapshot {
var data;
var id;
}

```
  
This file acts as an interface, and can be prepared simply creating all the classes and methods marked with a red underscore.
In Android it's possible to hover your mouse over the red underscores and select the *quick fix* :  
>Create class %%%%%  

or

>Create method %%%%%


A similar thing is done inside the database_interface.dart, where the classes span in 2 different classes.
  
We hence need 2 more stubs.  

```
import 'firestore_stub.dart'
if (dart.library.html)
  'package:firebase/firebase.dart';

import 'firebase_stub.dart'
  if (dart.library.html)
 'package:firebase/firestore.dart';

```
  
Voila! The IDE is not complaining anymore.

# How are you managing the loading system to be responsive?

Every time the user is waiting for an asynchronous task, we have to start immediately some animation. In this project, we are also denying the user to issue other commands before the other is completed. So the build method disables the RaisedButtons simply placing a `null` in their onPressed property.    
The naïve solution to this problem is to create a bool named loading, to check if the bool is true or false every time we build our view, and to call a setState every time we start or finish a loading.  
A cleaner way is to call two methods that make the loading start or stop.  
A more clean way, in my opinion, is to create a helper class that cares about it.  
Calling the method is made by passing a refresh method in the properties:  

>Helper.startLoading(refresh);  
  
>Helper.stopLoading(refresh);  
  
>static void startLoading(callback){ _loading=true; callback();}
  
>static void startLoading(callback){ _loading=false; callback();}
  
In this way we can start or stop the loading even if we change view with the navigator, and we can use these methods also during the integration test.  
The callback is a simple method that checks if the state is still mounted (it will not be mounted if the view has been removed).  
  
  

# Integration test
  
Inside the file `integration_test/app_test.dart` you can find a complete set of tests for the app.
The integration test works with the use of the integration_test: ^1.0.0 plugin  
  
The project contains a file inside test_driver/integrationd_driver.dart
that loads a custom driver:  

```
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```  


To launch the tests for android,ios,or wearOs,  
first launch the emulator (or connect the physical device)
then run the command  
>flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart
  
The test can also be launched for Web, but you will have to install the chromedriver first, at  
https://chromedriver.chromium.org/downloads
  
then run 2 commands in 2 different terminals:  
>chromedriver --port=4444  

>flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart -d web-server

*The integration test has a small bug for web. The chrome driver will NOT send you a log for every test, and there's nothing to do about it because it depends on Chrome Developers.  
But it's a very small bug. Because, if the tests have no errors, you will get  'ALL TESTS PASSED', and if you have an error, you will get the error log for that error in the expected way.*

Let's explain shortly the commands found in the test set.  

command | meaning
------- | -------
await tester.pumpWidget(app.FirebaseCrudExampleApp()); | Opens the app and waits for the loading.
find.textContaining('Ready!') | Can find a specific text in the App
expect(finder, findsOneWidget) | If this expectation is false, stop testing and throw error
expect(finder, findsNWidgets(2)) | Same, but with N results accepted (in this case, 2)
await tester.ensureVisible(formCaption); | Moves the scroll until the widget is visible
await tester.pumpAndSettle(); | Will wait until the UI has finished all animations
await tester.tap(find.bySemanticsLabel('Delete',skipOffstage: false)); | Taps on a widget marked by his semantics

This integration test has 4 tests:  
1 : checks if we have an error when READING, if the database is empty  
2 : checks if we have an error when UPDATING, if the database is empty  
3 : checks if we have an error when DELETING, if the database is empty  
4 : does all those operations:
  CREATE a record with SANDRO MANZONI as firstname and lastname  
  READ it to check if the data is correct  
  UPDATE it with the name ALESSANDRO as firstname  
  (This will expect 2 "alessandro" to be shown, thus testing also the LISTEN  
  DELETE the record  
    
  If no errors are found, you will be able to see the satisfying message "ALL TESTS PASSED."


# Thanks and apologies  

Please contact me for any typo/error/mistake that you encounter in this Repository. 
  

Make contact with me at  

https://www.linkedin.com/in/eugenio-amato-developer  

eugenioama@hotmail.com  


