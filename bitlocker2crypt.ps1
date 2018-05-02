<#	
	.NOTES
	===========================================================================
	 Created by:   	Johnny Ramos
	 Filename:     	bitlocker2crypt.ps1
	===========================================================================
	.DESCRIPTION
		Method to escrow a Windows Bitlocker key to Crypt-Server.
#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$crypt_url = 'https://crypt.yourdomain.nil/checkin/'

$serial = (Get-CimInstance Win32_ComputerSystemProduct).IdentifyingNumber

$username = (& "$PSScriptRoot\Get-LoggedOnUser.ps1" -ComputerName $env:COMPUTERNAME).UserName

$macname = $env:COMPUTERNAME


$bitLocker = Get-WmiObject `
               -Namespace "Root\cimv2\Security\MicrosoftVolumeEncryption" `
               -Class "Win32_EncryptableVolume" `
               -Filter "DriveLetter = '$env:SystemDrive'"

$protector_id = $bitLocker.GetKeyProtectors("0").volumekeyprotectorID

Foreach ($item in $protector_id) {
  $data = manage-bde -protectors -get $env:SystemDrive -id $item
  $key = ($data | Select-String -Pattern 'Password:' -Context 0,1 | % {$_.Context.PostContext})
  if ($null -eq $key) {
    continue
  } else {
    $rec_key = $key[1] -replace ' ',''
    $postData = "recovery_password=$rec_key&serial=$serial&username=$username&macname=$macname"
    if ($rec_key.length -eq 55) {
      curl `
        -UseBasicParsing `
        -Uri $crypt_url `
        -Method Post `
        -Body $postData `
        -ContentType application/x-www-form-urlencoded `
        -Verbose
    }
  }
}
