#!/bin/bash

#######
#Choice environment statement
#######

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
		-e|--env)
		ENV=$2
		shift ;;
	esac
	shift
done

if   [[ $ENV = "" ]]; then
	printf "ERR: forgot [-e; --env] attr\n"
	exit 1
elif [[ $ENV = "dev" ]]; then
	export ENV_NAME="development.env"
	env_dir="./environments/development.env"
elif [[ $ENV = "prd" ]]; then
	export ENV_NAME="production.env"
	env_dir="./environments/production.env"
else
	printf "ERR: attr [-e; --env] is incorrect, use: dev, prd\n"
	exit 1
fi


#######
#Parse environment attributes
#######

while IFS="=" read lhs rhs
do
	if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
		rhs="${rhs%%\#*}"
		rhs="${rhs%%*( )}"
		rhs="${rhs%\"*}"
		rhs="${rhs#\"*}"
		#declare $lhs="$rhs"
		export $lhs="$rhs"
	fi
done < $env_dir


#######
#Run docker-compose
#######

docker-compose up #-d
