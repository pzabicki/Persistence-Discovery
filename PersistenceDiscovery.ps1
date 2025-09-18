<#
.SYNOPSIS
  Output forms of persistence in place on host.
   
.DESCRIPTION
  PD (Persistence Discovery), is a script designed to search and output numerous forms of persistence on the host.
  It includes the following persistence locations:
 
 
   > Registry Run Values
   > Registry Winlogon Values
   > Registry Installed Components Keys
   > Services
   > Schedule Tasks
   > Startup Folders
 
.PARAMETER
  None
.INPUTS
  None
.OUTPUTS RTR Screen
  Will provide all output to RTR screen.
.NOTES
  Version:        1.0
  Author:         Collin Montenegro
  Creation Date:  02/15/2020
  Purpose/Change: Initial script development
.EXAMPLE
  N/A
#>
 
#-------------------------------[Functions]-----------------------------
 
function RegistryPersistence
{
  echo "`n";
  echo '++++++++++++++++++++++++++++++'
  echo 'REGISTRY PERSISTENCE RESULTS';
  echo '++++++++++++++++++++++++++++++'
  echo "`n";
  echo '===========================================================================';
  echo 'HKEY_USERS\S-1-5-21*\Software\Microsoft\Windows\CurrentVersion\Run Values';
  echo '===========================================================================';
  gi -path 'Registry::HKEY_USERS\S-1-5-21*\Software\Microsoft\Windows\CurrentVersion\Run\' -ea silentlycontinue | out-string ;
 
  echo "`n";
  echo '======================================================================================';
  echo 'HKEY_USERS\S-1-5-21*\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run Values';
  echo '======================================================================================';
  $wow6432key=test-path 'Registry::HKEY_USERS\S-1-5-21*\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\' -ea silentlycontinue;
 
  if ($wow6432key -eq $False)
    {echo "> There are no Wow6432Node\Microsoft\Windows\* Run Values"; echo "`n";}
 
    Else {
      gi -path 'Registry::HKEY_USERS\S-1-5-21*\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\' -ea silentlycontinue | out-string;}
     
  echo "`n";
  echo '==================================================================================';
  echo 'HKEY_USERS\S-1-5-21*\Software\Microsoft\Windows NT\CurrentVersion\Winlogon Values';
  echo '==================================================================================';
  gi -path 'Registry::HKEY_USERS\S-1-5-21*\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -ea silentlycontinue | out-string;
   
  echo "`n";
  echo '=============================================================================';
  echo 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run Values';
  echo '=============================================================================';
  $explorerunkey=test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\' -ea silentlycontinue;
 
  if ($explorerunkey -eq $False)
    {echo "> There are no HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run Values"; echo "`n";}
 
    Else {
    gi -path 'Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\' -ea silentlycontinue | out-string;
    }
 
  echo "`n";
  echo '======================================================================';
  echo 'HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run Values';
  echo '======================================================================';
  $explorerunkey=test-path 'Registry::HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\' -ea silentlycontinue;
 
  if ($explorerunkey -eq $False)
    {echo "> There are no HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run Values"
    echo "`n";}
 
    Else { gi -path 'Registry::HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\' -ea silentlycontinue | out-string;}
 
  echo "`n";
  echo '===========================================================';
  echo 'HKLM\Software\Microsoft\Windows\CurrentVersion\Run Values';
  echo '===========================================================';
  gi -path 'Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run\' -ea SilentlyContinue | out-string;
  
 
echo "`n";
echo '===============================================================';
echo 'HKLM\Software\Microsoft\Active Setup\Installed Components Keys';
echo '===============================================================';
$componentskey=test-path 'Registry::HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\*' -ea silentlycontinue;
 
  if ($componentskey -eq $False)
    {echo "> There are no HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components keys"
    echo "`n";}
 
    Else {gi -path 'Registry::HKLM\Software\Microsoft\Active Setup\Installed Components\*' -ea SilentlyContinue | out-string;}
}
 
function Services
{
  echo "`n";
  echo '++++++++++++++++++'
  echo 'SERVICES RESULTS';
  echo '++++++++++++++++++'
  echo "`n";
  echo '===================================================================';
  echo 'Services Excluding Any That Have a Pathname Containing svchost.exe';
  echo '===================================================================';
  gwmi win32_service |select name,pathname | ?{$_.pathname -notlike '*svchost.exe*'} | fl | out-string;
}
 
function ScheduledTasks
{
  echo '++++++++++++++++++++++++'
  echo 'SCHEDULED TASKS RESULTS';
  echo '++++++++++++++++++++++++'
  echo "`n";
  echo '==============================================================';
  echo 'Scheduled Tasks Calling a Binary With a .exe File Extension';
  echo '==============================================================';
  echo "`n";
  schtasks /query /fo list /v |findstr /i .exe;
}
 
function StartupFolder
{
  echo "`n"
  echo '++++++++++++++++++++++++'
  echo 'STARTUP FOLDER RESULTS';
  echo '++++++++++++++++++++++++'
  echo "`n";
  echo '=====================================';
  echo 'Persistence via User Startup Folder';
  echo '=====================================';
  $startupfiles = test-path 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*' -ea silentlycontinue;
  if ($startupfiles -eq $False)
    {Write-Host "> There are no files located in User startup folders"}
  Else {gci -path 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*' -ea silentlycontinue | select fullname | out-string; }
 
  echo '===========================================';
  echo 'Persistence via ProgramData Startup Folder';
  echo '===========================================';
  $startupfiles2 = test-path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*' -ea silentlycontinue;
  if ($startupfiles2 -eq $False)
        {echo "> There are no files located in ProgramData startup folder"}
  Else {gci -path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*' -ea silentlycontinue | select fullname | out-string;}
}

RegistryPersistence
Services
ScheduledTasks
StartupFolder
