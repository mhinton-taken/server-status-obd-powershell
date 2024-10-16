# server-status-obd-powershell
A Powershell script to query the Windows computer for various parameters.  Then write these parameters out to a file.   

Parameters: 
Server uptime
Server disk space usage listing percentage free
Five most recent error entries in Application and System log 
Check and list running Windows services
Check status of hosted websites. This parameter is for a locally hosted internal website.

Why the project is useful?
If this script is scheduled to run once a day (or more), there's a local record of the above parameters at that moment. These parameters can be reviewed periodically or after an incident to help diagnose the problem.
Example:  Let's assume this script runs daily at 0305 each day. Server xyz was reported as being down over the weekend.  The log files for the corresponding days are reviewed on Monday.  
Questions to ask: Does the uptime look to be about what you would expect? Perhaps the disk space filled up?  How does the uptime look on the different days? 

