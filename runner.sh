#!/bin/bash

echo "Building docker image..."
docker build -t gatsby .

echo ""
echo "Running docker image..." 
sleep 3
docker container run -d -m 1024M -p 8000:8000 --restart always --name gatsby gatsby:latest


echo -n "Do you want to enable ufw for Fedora machine? ['y' or 'n']: "
read ynoh

case $ynoh in

        [yY] | [yY][Ee][Ss] )
                "Opening all ports for Fedora local ip..." && sleep 3
                sudo ufw enable
                sudo ufw allow from 192.168.1.92
                EXIT_CODE=$?
                if [ $EXIT_CODE -eq 0 ]; then 
                echo "Success."
                else
                    echo "Failed to enable ufw!" && exit 1
                fi
                ;;
        [nN] | [n|N][O|o] )
                exit 0
                ;;
        

        *) echo -e "\nInvalid option.";
            ;;
esac

# Test
# curl --insecure http://192.168.1.64:8000