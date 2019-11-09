

CURRENT_USERS="$(sudo awk -F':' '$3 ~ "1701"{next}{print $1}' /etc/shadow)"
ALLOWED_USERS_FILE="$(readlink -f $(dirname -- "$0"))/allowedUsrs"
ALLOWED_USERS="$(awk -F':' '{print $1}' $ALLOWED_USERS_FILE)"

for USER in $CURRENT_USERS; do
#Check if not allowed on system (and remove)
	if echo "$ALLOWED_USERS" | grep -q "$USER"
		then
			echo "$USER is allowed"
		else
			echo "$USER is NOT allowed"
			#sudo userdel -f $USER
	fi
#Add ALLOWED_USERS that aren't in CURRENT_USERS
	for ALLOWED_USER in $ALLOWED_USERS; do
		if ! echo "$CURRENT_USERS" | grep -q "$ALLOWED_USER"
			then
				#sudo useradd -m $USER
				#echo "$ALLOWED_USER:password" | chpasswd
		fi
	done
					
#Check if in not allowed groups (and remove)
#Check if NOT in an allowed group (and add)

done


#Check allowed user
#for USER in $ALLOWED_USRS; do
#Collect info


#https://wiki.ubuntu.com/Security/Privileges


#ALLOWED_GROUPS="$(grep USER $ALLOWED_USRS_FILE | awk '{$1=""; print $0}')"
#CURRENT_GROUPS="$(id -Gf $USER)"


