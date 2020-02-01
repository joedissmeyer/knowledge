REM ---- Runs SQL Server Management Studio as a different domain user

runas /netonly /user:mydomain/myuser /pass:P@55w0rd "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
