(gc regedit.reg) -replace '"EnableFirewall"=dword:00000001', '"EnableFirewall"=dword:00000000' -replace '"EnableFirewall"=dword:00000000', '"EnableFirewall"=dword:00000000' | Out-File regedit.reg
pause