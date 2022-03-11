#! /usr/bin/bash

#function to run whois, will get the domain name from mainFun
#--------------------------------
runWhois() {
echo "-----------------------------------------------------------------------------"
echo "Please find the WhoIs details for" $1 "below"
echo "-----------------------------------------------------------------------------"

echo "-----------------------------------------------------------------------------"
echo "Registrar Details"
echo "-----------------------------------------------------------------------------"
whois $1 | grep 'Registrar WHOIS Server:' | tail -1
whois $1 | grep 'Registrar URL:' | tail -1
whois $1 | grep 'Updated Date:' | tail -1
whois $1 | grep 'Creation Date:' | tail -1
whois $1 | grep 'Registrar Registration Expiration Date:' | tail -1
whois $1 | grep 'Registrar:' | tail -1
whois $1 | grep 'Registrar Abuse Contact Email:' | tail -1
echo "-----------------------------------------------------------------------------"
echo "Registrant Details:"
echo "-----------------------------------------------------------------------------"
whois $1 | grep -m1 'Registrant Name:'
whois $1 | grep -m1 'Registrant Organization:'
whois $1 | grep -m1 'Registrant Country:'
whois $1 | grep -m1 'Registrant Email:'
echo "-----------------------------------------------------------------------------"
echo "Admin Details:"
echo "-----------------------------------------------------------------------------"
whois $1 | grep -m1 'Admin Name:'
whois $1 | grep -m1 'Admin Organization:'
whois $1 | grep -m1 'Admin Country:'
whois $1 | grep -m1 'Admin Email:'
echo "-----------------------------------------------------------------------------"
echo "Tech Details:"
echo "-----------------------------------------------------------------------------"
whois $1 | grep -m1 'Tech Name:'
whois $1 | grep -m1 'Tech Organization:'
whois $1 | grep -m1 'Tech Country:'
whois $1 | grep -m1 'Tech Email:'
echo "-----------------------------------------------------------------------------"
echo "Name Servers"
echo "-----------------------------------------------------------------------------"
whois $1 | grep 'Name Server:' | tail -4

echo "-----------------------------------------------------------------------------"
echo "Canonical Name"
echo "-----------------------------------------------------------------------------"
nslookup "www."$1 | grep 'canonical'

echo "-----------------------------------------------------------------------------"
echo "A Record" $1
echo "-----------------------------------------------------------------------------"
dig +noall +answer $1

}



#function to run Whois for Ip address
runWhoisIP(){
echo "-----------------------------------------------------------------------------"
echo "Please find the WhoIs details for" $1 "below"
echo "-----------------------------------------------------------------------------"
whois $1 | tail -n +11 | head -n -10
echo "-----------------------------------------------------------------------------"
echo "A Record" $1
echo "-----------------------------------------------------------------------------"
dig -x $1 | grep 'ANSWER SECTION' -A 1
}




#main function to determine the domain name and send it to runWhois function
#-----------------------------
mainFun() {

echo "Please enter the website for WhoIs"
read input

#to check if there are any spaces in the reading, if yes will call mainFun again

if [[ "$input" =~ \ |\' ]] 
then
 echo "There is a space please do it again without space."
 mainFun 
else
 if [[ $input =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]] #checks if email
 then
  email=$(echo "$input" | egrep -o '@+[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]')
  dom=$(echo "$email" | cut -c 2-)
  runWhois "$dom"
 elif [[ $input == *"www."* ]] #checks if website
 then
  webs=$(echo "$input" | egrep -o 'www.+[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]')
  dom=$(echo "$webs" | cut -c 5-)
  runWhois "$dom"
 elif [[ $input =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]] #checks if IP
 then
  dom=$input
  runWhoisIP "$dom"
 elif [[ $input =~ ^[a-zA-Z0-9\.-]+\.[a-zA-Z]{2,4}$ ]] #checks if only domain
 then
  dom=$input
  runWhois "$dom"
 else
  echo "You have entered a wrong domain, email, website or Ip address. Please retry."
  mainFun
 fi 
fi
}
#--------------------------------
#mainFun ends
mainFun
