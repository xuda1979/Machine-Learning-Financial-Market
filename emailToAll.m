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

file=fopen('C:\Company\EmailCompaign\email list\emaillist365.txt');
xiao=textscan(file, '%s', 'delimiter', '\n');
 
xiao=[xiao{:}];
[m,n]=size(xiao);

for i=1:m
 % Send the email. Note that the first input is the address you are sending the email to
 try
sendmail(xiao(i),'Global Stock Index Daily Prediction','Please see our daily release http://aatsys.com/cn/download.html');
i
 catch
 end
    
end