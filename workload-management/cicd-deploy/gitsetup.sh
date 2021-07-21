export URL=$(aws codecommit get-repository --repository-name ecs-anywhere-repo | jq -r .repositoryMetadata.cloneUrlHttp)
cd app
rm -Rf gitrepo
mkdir gitrepo
cd gitrepo
#git clone $URL .
git clone codecommit://ecs-anywhere-repo .
cp -Rf ../Dockerfile ../index.html .
git add .
git commit -m "Initial commit"
git push