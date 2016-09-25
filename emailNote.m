% Define these variables appropriately:
mail = 'exutechnology@gmail.com'; %Your GMail email address
password = 'dongfeng09'; %Your GMail password

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email. Note that the first input is the address you are sending the email to
sendmail('exutechnology@gmail.com','Update net','Please check the update of our predictions at http://aatsys.com/releaseTableCHZ.php',{'C:\Company\matlab files\EURJPYnet.mat'});
 
