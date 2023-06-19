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

can get $AwsProfile from 
```
%HOMEPATH%\.aws\config
```

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

**FUNCTIONALITIES** : 

* Create shortcuts to execute aws ec2 stop/start-instances command, according to instance status (running/stopped).
  * Only valid for 'stop-only' Schedule tags, this is to avoid accidently stopping CC shared instances.
* If the instance is being started or stopped, it will create a shortcut to show details of the instance (aws ec2 describe-instances command).
* Support config file.
* If multiple instances are started, it will create a special shortcut to stop all the running instances in one click.


**NOT SUPPORTED** :

* sso refresh token seems not supported.
* When clicking on shortcut it will open a cmd windows. Silent execution "cmd /c /q" with .lnk shortcut seems not working.


Note that it will not modify in any way the instances. The only aws cli commands used are :
aws ec2 describe-instances
aws ec2 start-instances
aws ec2 stop-instances
