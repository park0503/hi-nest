name="test"

aws --version
aws configure set default.aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set default.aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set default.region ap-northeast-2
aws configure set default.output json

container_definition="[
  {
    \"name\": \"$name\",
    \"image\": \"$REPOSITORY_URL\",
    \"portMappings\": [
      {
        \"containerPort\": 8080,
        \"hostPort\": 8080,
        \"protocol\": \"tcp\"
      }
    ],
    \"environment\":[]
  }
]"

task_definition=$(aws ecs register-task-definition \
--container-definitions "$container_definition" \
--family test \
--execution-role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/ecsTaskExecutionRole" \
--task-role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/ecsTaskExecutionRole" \
--network-mode "awsvpc" \
--requires-compatibilities "FARGATE" \
--cpu "$AWS_ECS_CONTAINER_CPU" \
--memory "$AWS_ECS_CONTAINER_MEMORY")

echo 
