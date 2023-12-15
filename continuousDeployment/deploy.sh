#!/bin/bash


set -e 

echo "This is a script to run a release deployment"
##################
# Install yq
# export VERSION=v4.25.1
# export BINARY=yq_linux_amd64
# wget https://github.com/mikefarah/yq/releases/download/$VERSION/$BINARY -O /usr/bin/yq && chmod +x /usr/bin/yq
##################

# Check if a tagVersion argument is provided as input to run the script else exit
if [ -z "$1" ]; then
  echo "Usage: $0 <input image_tag to deployment>"
  exit 1
fi

echo "####### ####### ####### ####### #"
echo "##### Define ENV                #"
echo "############### ####### ####### #"

# Set docker registry/repository
export DOCKER_REPO="lumszy/turotest"
export RELEASE_TAG=$DOCKER_REPO:$1
export BASE=main
export WORKDIR=~/Documents/turo/$1
export repositoryURL=git@github.com:lumszy/turotest.git
export branchName=$1


echo "####### ####### ####### ####### ######### ###################"
echo "##### Check if release branch exists locally                #"
echo "############### ####### ####### #############################"


# Check if the branch exists locally
if git rev-parse --verify --quiet "$branchName" > /dev/null; then
    echo "Branch $branchName exists locally."
    # Perform actions for an existing branch
    # For example, switch to the existing branch
    git checkout "$branchName"
    git pull origin main
else
    echo "Branch $branchName does not exist locally."

    # Clone the repository if it doesn't exist locally
    #git clone --branch "$branchName" --single-branch "$repositoryURL"

    #git clone $repositoryURL $branchName
    git checkout -b $branchName 
    git pull origin main
    

    # Change into the cloned repository directory
    #cd "$(basename "$repositoryURL" .git)"

    # Additional actions for a newly cloned repository, if needed
fi
echo Done


# Clone Application repo
# echo "Git Clone application repo"
# gh repo clone git@github.com:lumszy/turotest.git .


#Create & checkout to release branch"
#echo "Checkout to release branch"
#git checkout -b $branchName


# Current image tag 
export current_tag=$(yq -e '.spec.template.spec.containers[0].image' applicationDeployment/deployment.yml)
#echo $current_tag

echo "####### ####### ####### ####### ######### ###################"
echo "##### Update the deployment manifest with the new image tag #"
echo "############### ####### ####### #############################"

# Update the deployment manifest with the new image tag
#sed -i "s/$current_tag/$RELEASE_TAG/" ../applicationDeployment/deployment.yml
yq -e ".spec.template.spec.containers[0].image = \"$RELEASE_TAG\"" -i applicationDeployment/deployment.yml


echo "####### ####### ####### ####### ######### ######### #########"
echo "##### Run release using terraform (Continuous deployment)   #"
echo "############### ####### ####### ######### ###################"

echo "Deploying RELEASE_TAG" $RELEASE_TAG
cd terraformDeployment
terraform init
terraform plan -out=tfplan
terraform apply tfplan 


echo "####### ####### ####### ####### #######"
echo "##### # Pushnig changees back to git. #"
echo "############### ####### ####### #######" 


# git add ../applicationDeployment/*.yml
#cd $WORKDIR
git add -A
echo "git add complete"

# run git commit
git commit -m "Deploy release version $RELEASE_TAG"
echo "running git commit is completed"

# Push the changes to the remote branch 
git push origin #$1
echo "Push the changes to the remote branch completed"

# Create a pull request
gh pr create --base $BASE --head $1 --title "$1 Release to Prod" --body "This pull request $1, adds a new feature to the project."
echo "Create pull request Completed"

echo ""
echo "Done"

#https://cli.github.com/manual/gh_repo_create

