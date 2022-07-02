echo "====== 1. Run dagster daemon"
Start-Process -FilePath "powershell" -WorkingDirectory $PWD -ArgumentList {
    ".\.venv\Scripts\Activate.ps1";
    "$Env:DAGSTER_HOME = $PWD";
    "dagster-daemon run";
}

echo "====== 1. Run dagit"
Start-Process -FilePath "powershell" -WorkingDirectory $PWD -ArgumentList {
    ".\.venv\Scripts\Activate.ps1";
    "$Env:DAGSTER_HOME = $PWD";
    "dagit";
}

