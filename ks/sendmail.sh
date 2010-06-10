#
# http://network-13.com/thread/1718-1-Sendmail-smtp-relay-gmail-google-apps
#
yum install sendmail sendmail-cf

cd /etc/mail
hostname -f > genericsdomain
touch genericstable
makemap -r hash genericstable.db < genericstable
mv sendmail.mc sendmail.mc.original
wget http://pbxinaflash.net/source/sendmail/sendmail.mc.gmail
# If the above file is no longer available I've uploaded a mirror here
# wget http://network-13.com/sendmail.mc.gmail
cp sendmail.mc.gmail sendmail.mc
mkdir -p auth
chmod 700 auth
cd auth
Edit (vi or cat >>) client-info
AuthInfo:smtp.gmail.com "U:smmsp" "I:user_id" "P:password" "M:PLAIN"
AuthInfo:smtp.gmail.com:587 "U:smmsp" "I:user_id" "P:password" "M:PLAIN"
# Replace  user_id with your gmail username without @gmail.com
# If you're using google apps then enter your full email address user@yourdomain.com
# Replace password with your own gmail/google apps password
# Save your changes (Ctrl-X, Y, then Enter)
chmod 600 client-info
makemap -r hash client-info.db < client-info
cd ..
make
service sendmail restart


#
# Test
#
echo "Test" | mail user@domain.com
