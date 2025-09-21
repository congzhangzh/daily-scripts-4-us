#!/bin/bash
# upstream: https://github.com/xykt/NetQuality
#docker run --rm --net=host -it --entrypoint bash xykt/check  -n -y -f -p  
docker run --rm --net=host -it --entrypoint /bin/bash xykt/check -c 'bash <(curl -Ls Net.Check.Place) -n -y -f -p'  
