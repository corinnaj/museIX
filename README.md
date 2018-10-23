# museIX
A collaborative, interactive music performance framework developed using Processing.

## Set Up
### Step 1 - Setting up sketches on Android:
Open the `client` sketch in Processing.
On the top right, select `Add Mode` in the drop down.
Choose the Android Mode and follow the setup.
Restart Processing and select Android Mode, install the SDK or choose an already installed SDK.  

### Step 2 - Create a local network:
If you are using Linux, simply go to Wifi settings and create a local Hotspot. Use your phone to connect to the hotspot.  
If you are using Windows or Mac, it might be easier to start a local hotspot on your phone and connect your computer to it.

You might also need to adjust the IP address at the top of `client/communication.pde`

### Step 3 - Run both sketches:
Open the Sketch `soundExperiments` in Processing and start it (in Java Mode).
In a second Processing window, open the client sketch and run it in Android mode.
Make sure you have USB debugging enabled on your phone.

### Step 4 - Connecting the dots:
Your phone should appear as an input on your computer. You can now connect it to different instruments.

## How to use
You can create new instrument nodes by clicking on the various buttons at the top of the server component.
Connect two nodes by dragging one over the other.
Disconnect nodes by dragging the mouse over the connecting lines.

## Development
### Libraries  
We are currently using the `Beads` library for sounds and `Ketai` as the Android hardware interface. Both can be installed via the default library installer in the Processing IDE.
