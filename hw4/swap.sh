#!/bin/bash

function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}

# Determine if web1 or web2 is running
# If check1 == 0, web1 is running
docker ps | grep --quiet "web1"
check1=$?

# If check2 == 0, web2 is running
docker ps | grep --quiet "web2"
check2=$?

# If web1 is running
if [[ $check1 -eq 0 ]]; then
    echo "Web1 is running"

    # Kill web2 if running
    killitif web2

    # Bring up web2 with the image activity2
    echo "Bringing up web2 with" $1
    docker run -d --network ecs189_default --name web2 $1

    # Swap to web2
    echo "Swapping to web2"
    sleep 3 && docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh

    # Kill web1
    echo "Killing web1"
    sleep 3 && killitif web1
elif [[ $check2 -eq 0 ]]; then
    echo "Web2 is running"
    # Kill web1 if running
    killitif web1

    # Bring up web1 with the image activity
    echo "Bringing up web1 with" $1
    docker run -d --network ecs189_default --name web1 $1

    # Swap to web1
    echo "Swapping to web1"
    sleep 3 && docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh

    # Kill web2
    echo "Killing web2"
    sleep 3 && killitif web2
fi