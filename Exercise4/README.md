
Troubleshooting 503 Error Response from Web Application


Step 1: Checked the logs in event viewer, found that Application Pool is in stopped state because application pool identity configured in default application pool is invalid.

Step 2: Checked the application pool settings, found that custom user account "AppPoolServiceUser" is configured as an identity. The issue is we dont know the exact credentails provided while confguring the custom account.

Step 3: I have changed the application pool identity from custom account to Built-in Account, And in Built-in account I have selected the ApplicationPoolIdentity option.

Step 4: Accessed the website in browser, website gave 200 reponse.


We can also fix this issue in another way:

In step 2: we found that AppPoolServiceUser user account is created in the server, may be the password specified in the apppool identity is wrong.

Reset the password for the user account "AppPoolServiceUser".


Then we can confugure the appliation pool identity to use the custom account and provide the username as "AppPoolServiceUser" and the exact password that we have given in the previous step.



