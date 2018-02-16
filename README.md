# BeaconProximity
This is a sample iOS application in Swift to detect nearby iBeacons with a specific Major ID. It does the following:
- When you open the app, it will request permission to access the user's location to look for beacons.
- By toggling a switch, the user can start ranging for nearby beacons.
- Using a hard-coded UUID and Major ID, it will look for all nearby beacons that match those criteria.
- When beacons are detected, it will put them in a list, along with an approximate distance to that beacon (this data can be noisy).

## Approximating Location using iBeacon Proximity data
It is possible to get a rough estimate of the user's actual position by triangulating (trilateration) three or more iBeacon signals.
However, the signal can be very noisy, so this doesn't work too well out of the box. Here is a [collection of links](https://gist.github.com/joeblau/581f15f5adefd69b80ff) about the topic if
you are interested.

## Problems and Suggestions
If you encounter a bug or have a general question on how to expand this, please open an issue, and I will respond as soon as possible. Pull requests are welcome!
