# Create Secrets files
echo "{\"username\":\"someuser\", \"password\":\"securepassword\"}" | tee mycreds.json

# Create secrets manager
aws secretsmanager create-secret --name SECRET_TEST_AWS --secret-string file://mycreds.json

echo "Secrets successfully created"