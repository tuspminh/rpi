#!/bin/bash
SRC=$1
DEST=$2
 
SRC_GROUPS=$(groups ${SRC})
SRC_SHELL=$(awk -F : -v name=${SRC} '(name == $1) { print $7 }' /etc/passwd)
NEW_GROUPS=""
i=0
 
#skip first 3 entries this will be "username", ":", "defaultgroup"
for gr in $SRC_GROUPS
do
        if [ $i -gt 2 ]
        then
                if [ -z "$NEW_GROUPS" ]; then NEW_GROUPS=$gr; else NEW_GROUPS="$NEW_GROUPS,$gr"; fi
        fi
        (( i++ ))
done
 
echo "New user will be added to the following groups: $NEW_GROUPS"
 
useradd --groups ${NEW_GROUPS} --shell ${SRC_SHELL} --create-home ${DEST}
mkhomedir_helper ${DEST}
passwd ${DEST}
