$CmdCreatePythonVenv = 'python -m venv .venv'
$CmdInstallRequiredPackages = "pip install -r requirements.txt"
$EnvFilePath = ".\.venv\Scripts\Activate.ps1"
$DBTPathValue = "`n# DBT`n`$Env:DBT_PROFILES_DIR=""`$PWD/imdb_dbt"""

echo "====== 1. Create the virtual environment"
Invoke-Expression $CmdCreatePythonVenv

echo "====== 2. Adding DBT Profile path to the virtual environment"
$EnvContent = Get-Content $EnvFilePath
$EnvInsertLine = $(Select-String -Path $EnvFilePath -Pattern "# Add the venv to the PATH").LineNumber
$EnvContent[$EnvInsertLine+1] += $DBTPathValue
$EnvContent | Set-Content $EnvFilePath

echo "====== 3. Activate the environment"
Invoke-Expression $EnvFilePath

echo "====== 4. Install required packages"
Invoke-Expression $CmdInstallRequiredPackages

echo "====== 5. Create folder to store raw files"
mkdir raw_files

cd imdb_dbt
Invoke-Expression "dbt deps"
cd ..