$EnvFilePath = ".\.venv\Scripts\Activate.ps1"

echo "====== 1. Activate the environment"
Invoke-Expression $EnvFilePath

cd imdb_dbt

echo "====== 2. Generate documents"
Invoke-Expression 'dbt docs generate'

echo "====== 2. Start documentation site"
Invoke-Expression 'dbt docs serve'
