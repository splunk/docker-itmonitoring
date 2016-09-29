#https://docs.docker.com/engine/reference/commandline/build/
if [ -z $CURRENT ]; then
	CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

docker build --no-cache=true -t splunk/enterprisetrial:6.5.0-monitor -f ./enterprise/Dockerfile $CURRENT
docker build --no-cache=true -t splunk/enterprisetrial:latest -f ./enterprise/Dockerfile $CURRENT
