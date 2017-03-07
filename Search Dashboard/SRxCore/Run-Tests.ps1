
.\initSRx.ps1

New-SRxReport -RunAllTests

Test-SRx -RunAllTests

New-SRxReport -Test OSPowerPlan -Details
New-SRxReport -Test OSVolumeProperties -Details

