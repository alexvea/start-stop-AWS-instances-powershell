# start-stop-AWS-instances-powershell
Powershell script to create Windows shortcuts to start or stop AWS instances from specific User tag.

**PREREQUISITES** : 
1) Install aws cli on Windows :
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
2) Configure aws sso profile :
https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html#sso-configure-profile-token-auto-sso

**INSTALLATION** : 
1) Create a folder.
2) Download check_aws_instances.ps1 and config_file.ps1 and put in the freshly created folder.

**CONFIGURE** : 
1) Modify config_file.ps1 with User tag in $UserName and the name of aws sso profile (from step 2 of prerequisites) in $AwsProfile.
(example)
````
## Parameters to edit before executing the script
$UserName = "Avea"
$AwsProfile = "Virtu_CustomerCare-xxxxxxxxxxx"
````
**USAGE** : 

Right-click on the check_aws_instances.ps1 file and click on "Execute with powershell"
![Alt text](https://github.com/alexvea/start-stop-AWS-instances-powershell/blob/main/readme-screenshots/right-click-execute-powershell.png)

**RESULT** :
It will open a powershell windows and execute the script :
![Alt text](https://github.com/alexvea/start-stop-AWS-instances-powershell/blob/main/readme-screenshots/script-result.png)

And create a folder with shortcuts to start or stop instances :
![Alt text](https://github.com/alexvea/start-stop-AWS-instances-powershell/blob/main/readme-screenshots/start-stop-shortcuts.png)

Then you can click on any shortcut to start or stop the instance depending on it current state.

You can refresh instances states by clicking again on check_aws_instances.ps1.
Note that it will take few seconds for a instance to finish start or stop.


