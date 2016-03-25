# TTN Gateway for Raspberry Pi + IMST iC880A SPI

Resin Dockerfile & scripts for [The Things Network](http://thethingsnetwork.org/) gateways based on the iC880a concentrator with a Raspberry Pi host, connected using SPI.

## PREREQUISITES

1. Build one or more RPi + IMST iC880A SPI gateways as described in **Hardware Setup** here:  https://github.com/ttn-zh/ic880a-gateway/tree/spi
2. Create and sign into an account at http://resin.io, which is the central "device dashboard".  By using this dashboard you will be able to create the "boot SD" for your Raspberry pi.  When you use that SD card, Resin will recognize that Raspberry Pi as belonging to you, will then deliver the gateway software to your RPi, and will subsequently keep your RPi up-to-date with future updates to the gateway software.
3. Clone **this** github repo to your mac/pc.  That desktop repo will be subsequently used to instruct resin.io  what software to place on your gateway(s).

## PREPARING YOUR FIRST GATEWAY DEVICE FOR RESIN.IO

1. On resin.io, create an "Application" for managing your TTN gateway devices. I'd suggest that you give it the name "ttngw", select the appropriate device type (i.e. Raspberry Pi 2 or Raspberry Pi 3),  and click "Create New Application".  You only need to do this once, after which you'll be able to manage one or many gateways of that type.
2. You'll then be brought to the Device Management dashboard for that Application.  Follow the instructions to create a boot SD for your Raspberry Pi. (Pro Tip:  Use a fast microSD card and a USB 3 adapter if you can, because it can take a while to copy all that data. Either that, or be prepared to be very patient.)  Note that during the long process of waiting for the "sudo dd" command, if you're using a Mac you can press "Ctrl T" which will give you an interim progress report. 
3. When the (long) process of writing the image to the SD card completes, insert it into your Raspberry Pi, connect it to the network with Ethernet, and power it up.
4. After several minutes, on the resin.io Devices dashboard you'll now see your device - first in a "Configuring" state, then "Idle".  Click it to open the Devices control panel.
5. If you like, enter any new Device Name that you'd like, such as "gateway-1".

## PREPARING YOUR FIRST GATEWAY DEVICE FOR TTN

Click the "Environment Variables" section at the left side of the screen.  This will allow you to configure environment parameters for this and only this device, and which will be appropriately inserted into this device's "local_conf.json" with lowercase tuple names derived from the appropriate uppercase environment names beginning with "GW_".  For example, for a gateway with no GPS, the MINIMUM environment variables that you should configure at this screen should look something like this:

DEVICE ENVIRONMENT VARIABLES  

Name      	  	  | Value  
------------------|--------------------------  
GW_REGION         | EU
GW_CONTACT_EMAIL  | yourname@yourdomain.com     
GW_DESCRIPTION    | your-gateway-1  
GW_REF_LATITUDE   | 52.376364       
GW_REF_LONGITUDE  | 4.884232          
GW_REF_ALTITUDE   | 3          

## TRANSFERRING TTN GATEWAY SOFTWARE TO RESIN SO THAT IT MAY BE DOWNLOADED ON YOUR DEVICES

1. On your Mac or PC, in terminal, change your working directory to the directory that is the clone of **this** git repo.
2. Now, type the command that you'll see displayed in the edit control in the upper-right corner of the Resin devices dashboard for your device. This command "connects" your local directory to the resin GIT service, which uses GIT to "receive" the gateway software from TTN, and it looks something like this:

   git remote add resin youraccount@git.resin.io:youraccount/yourapplication.git

3. Type the following commands into terminal to "push" the TTN files up to resin.io:

   git add .
   git -m "first upload of ttn files to resin"
   git push resin master

5. What you'll now see happening in terminal is that this "git push" does an incredible amount of work:

   a) It will upload a Dockerfile, a "build script", and a "run script" to resin
   b) It will start to do a "docker build" using that Dockerfile, running it within a QEMU ARM virtual machine on the resin service.
   c) In processing this docker build, it will run a "build.sh" script that downloads and builds the packet forwarder executable from source code, for RPi+iC880A-SPI.
   d) When the build is completed, you'll see a unicorn ASCII graphic displayed in your terminal.

6. Now, switch back to your device dashboard, you'll see that your Raspberry Pi is now "updating" by pulling the Docker container from the resin.io service.  Then, after "updating", you'll see the gateway's log file in the window at the lower right corner.  You'll see it initializing, and will also see log output each time a packet is forwarded to TTN.  You're done!

## PRO TIPS

- At some point if you would like to add a second gateway, third gateway, or a hundred gateways, all you need to do is to add a new device to your existing Application. You needn't upload any new software to Resin, because Resin already knows what software belongs on the gateway. So long as the environment variables are configured correctly for that new device, it'll be up and running immediately after you burn an SD card and boot it.

- Resin will automatically restart the gateway software any time you change the environment variables.  You'll see this in the log.  Also, note that Resin restarts the gateway properly after power failures.  If the packet forwarder fails because of an error, it will also automatically attempt to restart.

- If you'd like to update the software across all the gateways in your device fleet, simply do the following:

  Edit the Dockerfile to bump the TTN_GATEWAY_VERSION number
  git add .
  git commit -m "Updated gateway version"
  git push resin master"

# Credits

[Gonzalo Casas](https://github.com/gonzalocasas) on the [iC880a-based gateway](https://github.com/ttn-zh/ic880a-gateway/tree/spi)  
[Ruud Vlaming](https://github.com/devlaam) on the [Lorank8 installer](https://github.com/Ideetron/Lorank)  
[The Team](https://resin.io/team/) at resin.io   
