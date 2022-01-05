# iOS-VML-Player

This is a framework that wraps the VML Web Player into a iOS framework so it can be embedded into an iOS application. The framework creates a 2 way communication betweent the JS Web Player and the iOS Framework.

## Deploying the Framework 

To deploy the framework:
  * Change the target to the BuildFramework target
  * Build the target
  * A framework folder will be generated that can be distributed to other 3rd party iOS applications
  * Note that this build framework target contains a runScript that enables the framework to be build for both device and simulator deployment 
  
  


## Adding the Player Framework to your Application

---

### Using Cocoapods

* Add the pod file reference to your iOS Target using the latest release.
```jsx
pod 'VMLPlayerController', :git => 'https://github.com/securebroadcast/iOS-VML-Player', :tag => '1.0.1'
```
* Pod install

## Using the Framework

---

1. In the view controller you want to use the framework in import the framework like so:

```jsx
import VMLPlayerController
```

2. The Player initialisation function takes 3 arguements:

- Player Data
- the player delegate
- Player Controls

3. Displaying the player

- The player view can be presented as a full screen player view via a present or push
- Or it can be embedded in a subview within a View Controller.

## Player Initialisation Arguements

---

**Player Data**

Player data is the data that will be shown within the VML video. The data points that should be passed into the player will be given to you by the VML Platform application. 

The parameter vml_id should always be passed into the player, this is the unique ID for your video. 

Data Example:

```swift
var playerData = NSMutableDictionary()
playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
playerData.setValue("Kris", forKey: "name")
playerData.setValue("Game VS Bryansburn", forKey: "session") 
playerData.setValue("8.14", forKey: "max_speed")
playerData.setValue("Saturday 29th May", forKey: "date")
playerData.setValue("1.98", forKey: "variation")
playerData.setValue("negitive", forKey: "trend")
```

**Player Controls**

You have the option to dictate if you want the video to auto play, auto loop and if you want the player controls to be displayed or hidden. The player controls object should be built up like:

```swift
let playerControls = PlayerControls(autoplay: false, autoloop: false, showPlayerControls: true)
```

**VMLPlayerDelegate**

The VML Player delegate has 1 function that informs you when an event in the player occurs. The Delegate should be implemented like:

```swift
extension ViewController: VMLPlayerDelegate {
    
    func playerDidPostEvent(event: PlayerEvent) {        
        
    }
}
```

PlayerEvent Class

```swift
public class PlayerEvent: Decodable {
    public var event: String? // Event Types: PLAYING, PAUSED, ELEMENT_CLICKED, COMPLETE, READY
    public var player_time: Float?
    public var meta_data: String? // IF Event is ELEMENT_CLICKED, meta_data = the Element ID that was clicked
}
```

**Example of player Initialisation and presenting**

```swift
var playerData = NSMutableDictionary()
playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
playerData.setValue("Kris", forKey: "name")
playerData.setValue("Game VS Bryansburn", forKey: "session") // "Game VS Newry City"
playerData.setValue("8.14", forKey: "max_speed")
playerData.setValue("Saturday 29th May", forKey: "date")
playerData.setValue("1.98", forKey: "variation")
playerData.setValue("negitive", forKey: "trend")

let playerControls = PlayerControls(autoplay: true, autoloop: true, showPlayerControls: false)
let playerViewController: playerViewController = VMLPlayerViewController(withData: playerData, delegate: self, playerControls: playerControls)
self.navigationController?.pushViewController(playerViewController, animated: true)
```
