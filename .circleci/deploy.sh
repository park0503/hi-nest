name="hi-nest"
JQ="jq --raw-output --exit-status"

aws --version
aws configure set default.aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set default.aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set default.region ap-northeast-2
aws configure set default.output json

container_definition="[
  {
    \"name\": \"$name\",
    \"image\": \"$REPOSITORY_URL\",
    \"repositoryCredentials\": {
      \"credentialsParameter\":\"$REPOSITORY_CREDENTIAL\"
    },
    \"portMappings\": [
      {
        \"containerPort\": 3000,
        \"hostPort\": 3000,
        \"protocol\": \"tcp\"
      }
    ],
    \"environment\":[]
  }
]"

task_definition=$(aws ecs register-task-definition \
--container-definitions "$container_definition" \
--family "$name" \
--execution-role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/ecsTaskExecutionRole" \
--network-mode "awsvpc" \
--requires-compatibilities "FARGATE" \
--cpu "$AWS_ECS_CONTAINER_CPU" \
--memory "$AWS_ECS_CONTAINER_MEMORY" | $JQ ".taskDefinition.taskDefinitionArn")

echo "$task_definition"

if [[ $(aws ecs update-service \
 --cluster "$name" \
 --service "$name" \
 --task-definition "$task_definition" | $JQ ".service.taskDefinition") != "$task_definition" ]];
 then
 echo "ERROR: Updating Service is Fail";
 return 1
else
  echo "Success Updating Service";
fi


for attempt in {1..30}; do
  if stale=$(aws ecs describe-services --cluster "$name" --services "$name" | \
                 $JQ ".services[0].deployments | .[] | select(.taskDefinition != \"$task_definition\") | .taskDefinition"); then
    echo "Waiting for stale deployment(s):"
    echo "$stale"
      sleep 30
  else
    echo "Deployed!"
    return 0
  fi
done