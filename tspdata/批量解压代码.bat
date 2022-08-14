for /r %1 %%i in (*tsp.gz*) do (
Bandizip.x64 x  -o: "%%i" 
)
pause