# Create new SSM parameter
aws ssm put-parameter \
    --name "PARAMETER_TEST_AWS" \
    --type "String" \
    --value "Hello world from SSM" \
    --overwrite


echo "Parameters created successfully"