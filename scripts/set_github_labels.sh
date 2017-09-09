echo ''
echo 'This script will remove the GitHub default labels and create the 80|20 process labels for your repo. A personal access token is required to access private repos.'

# Requires an access token from github that will have proper permissions
# to update the repos labels.
echo ''
echo -n 'GitHub Personal Access Token:'
read -s TOKEN

# Can either manually specify the repo with this code.
# echo ''
# echo -n 'GitHub Org/Repo (e.g. foo/bar): '
# read REPO

# Or specific an array of repos with this
export repoNames="
ORG_OR_OWNER/REPO_NAME_1
ORG_OR_OWNER/REPO_NAME_2
ORG_OR_OWNER/REPO_NAME_3
"

for repoName in $repoNames
do
  echo ''
  echo -n "GitHub Org/Repo (e.g. foo/bar): $repoName"
  export REPO=$repoName

  REPO_USER=$(echo "$REPO" | cut -f1 -d /)
  REPO_NAME=$(echo "$REPO" | cut -f2 -d /)

  # Delete default labels
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/bug
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/duplicate
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/enhancement
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/help%20wanted
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/invalid
  curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/wontfix
  # curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/ready%20for%20review

  # Dont delete the question label
  # curl -u $TOKEN:x-oauth-basic --request DELETE https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/question

  # Update existing labels
  # curl -u $TOKEN:x-oauth-basic --include --request PATCH --data '{"name":"work in progress","color":"faff5d"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/work%20in%20progress"
  # curl -u $TOKEN:x-oauth-basic --include --request PATCH --data '{"name":"ready for review","color":"00DB00"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/ready%20for%20review"
  # curl -u $TOKEN:x-oauth-basic --include --request PATCH --data '{"name":"do not merge","color":"ff1717"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels/do%20not%20merge"

  # Create new labels
  # curl -u $TOKEN:x-oauth-basic --include --request POST --data '{"name":"work in progress","color":"faff5d"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels"
  # curl -u $TOKEN:x-oauth-basic --include --request POST --data '{"name":"ready for review","color":"00DB00"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels"
  # curl -u $TOKEN:x-oauth-basic --include --request POST --data '{"name":"do not merge","color":"ff1717"}' "https://api.github.com/repos/$REPO_USER/$REPO_NAME/labels"
done
