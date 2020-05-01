service=$1
username=$2
token=$3

usage () {
  local errorMessage=$1
  echo
  echo "---------------------------------------------------------------"
  echo "Error: $errorMessage"
  echo "---------------------------------------------------------------"
  echo "usage: ./create-image-pullsecret.sh <service> <username> <token>"
  echo "  e.g. ./create-image-pullsecret.sh batman myuser mypass"
  echo "---------------------------------------------------------------"
  exit 1
}

if [ -z "$service" ]
then
  usage "No service specified"
fi


if [ -z "$username" ]
then
  usage "No username specified"
fi

if [ -z "$token" ]
then
  usage "No token specified"
fi

if [[ ! $service =~ ^[-a-z]{3,30}$ ]]
then
  usage "Username ${service} invalid. Username can only be lower-case letters, 3-12 characters in length"
fi

kubectl -n $service create secret docker-registry $service-pullsecret \
            --docker-server=docker.pkg.github.com \
            --docker-username="$username" \
            --docker-password="$token" \
            --dry-run -o yaml | kubectl apply -f - 