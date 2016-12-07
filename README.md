# HospitalDirectory
An application for multiple purposes pertaining to a hospital

## Synopsis

This project is aimed to provide the services of a hospital in an easy, fast way. It includes several features such as a medical directory, reminders of appointments and medicines and Pre-Admision screen to the hospital.

## Motivation

The project served as practice and learning task. It was created by students with the purpose of learning iOS programming, specifically in the Swift language. The acquired tools and knowledge of this programming language were:

1. User Interface: 
  * StoryBoard concept - a set of .xib files that together conform a scene. Each of these screens can be presented in different ways. 
  * Tab Bar Controller - An interface that organizes the app into different modules, each one containing a different view controller with independent hierarchy. 
  * Navigation Controller - An interface that organizes view controllers. It may have different levels of hierarchy, so the view controllers are presented in different ways (modally, pushed, etc.) depending on their function. The Navigation Item provides a NavBar that can contain up to three buttons, that can trigger different tasks. 
  * Alert Controller - An interface that appears when the user must respond to a request immediately. 
  * TableView Controller - A View Controller that contains a TableView that can be managed to present any type of data. 
  * Date Picker - A tool that helps the user pick a specific date and hour for an alarm or reminder. 
  * Picker View - It helps the user pick a specific data. This can contain any type of object. 
  * AutoLayout - A tool used to keep the correct distribution of the elements in a view. Any element must satisfy the four main constraints (width, height, x position, y position).

2. Swift 2.2: 
  * Guard function - A function that is used to check conditions in order to continue the execution of the code. 
  * Map function - It is used to transform the data of a structure into another type of data. It returns the mapped value.     * Flatmap function - It is used to transform an array of arrays into a simple array, taking out the nil values. 
  * Filter function - A function that depending on a given condition, filters the elements that meet this condition. It returns the filtered array of elements. 
  * Optional variables - A wrapped variable that can be either nil or have a value. 
  * Unwrapping of optional variables - Different techniques to obtain the value of an optional variable if it exists.         * Closure - A block of code that is used for a certain purpose. It manages any constants and variables that are in the context it is defined. 
  * Lazy variables - A variable that is initialized until the first time it is used. 
  * Casting - Converts a variable into a different type of value. Struct - A construct that can't be inherited. It is used to define properties, methods and initializers. When an object is instantiaded it creates a copy of the struct. 
  * Class - A construct that can be inherited and also defines objects. The objects are instantiated by reference.             * Dictionary - A data structure that consists of collections of data that are accessed by one or several keys.

3. iOS programming: 
  * Delegation - Communication between classes. It is applied when a certain object or class needs another object to do something in order to do its work. 
  * Notifications - Another form of communication between classes. When certain part of the app wants to notify a change, a notification is posted and then, listened by the "interested" object or class, so the task can continue. 
  * AppDelegate - The main object of the app. It is in charge of important events of app and external events that communicate the system with the program. 
  * Threads - Concurrent processes in the runtime of the app. The GUI is always drawn in the main thread. The notifications are listened in the same thread in which they are posted. Altern threads are executed before the main thread. 
  * Class functions - Functions that can be accessed without the need of an instance. 
  * Local notifications - Notifications from the app when an internal event has to be attended.

4. Software architecture: 
  * MVVM - An architecture, which principle is to separate, the managing of the view from the managing of data. Its purpose is to avoid excessive amount of work for the View Controller, which is only in charge of the presentation of data. The advantage is that the maintenance of the code is much more easier.

## Contributors

David Mar - e-mail: davidma_96@hotmail.com 
Marilyn García - e-mail: marilyn_gm@outlook.com 
Fernando Olivares - Twitter: @olivaresf
