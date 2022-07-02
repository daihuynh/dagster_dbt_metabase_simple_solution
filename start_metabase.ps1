echo "Starting Metabase in Docker"
$Command = "docker-compose -f bi_stack.yml up -d"
Invoke-Expression $Command