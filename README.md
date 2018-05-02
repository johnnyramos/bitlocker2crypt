# **Bitlocker 2 Crypt**

Method to escrow a Windows Bitlocker key to [Crypt-Server](https://github.com/grahamgilbert/Crypt-Server).

Crypt-Server was first meant to recover filevault keys from Mac OS operating systems. If you're a Multi-OS Client Platform Engineer like myself, I needed a way to manage other OS encryption keys without having to use yet another portal per OS.

Provided is a generic script. Kept this simple as I'm sure others can functionalize it.

## Requirements
- `Get-LoggedOnUser.ps1` - This scipt was pulled from [TechNet](https://gallery.technet.microsoft.com/Get-LoggedOnUser-Gathers-7cbe93ea).
  - I've included the current one in this repo.
  - We will need to use `Get-LoggedOnUser.ps1` to get the currently active user logged into Windows.

## Tested On
- Windows 10 Enterprise
- Windows 10 Pro

## How to use it?

Depends on the method or management system you plan to use.

- #### Powershell
  - Since the `Get-LoggedOnUser.ps1` file is not signed by a certificate, I am calling `Powershell` with a `ByPass`. This all depends on your execution policy.
    - InfoSec might not like this, so the recommended way is to sign all code deployed.
  - Please ensure these files are in the same directory when executing.
  ```powershell
  powershell.exe -noprofile -executionpolicy bypass -file .\bitlocker2crypt.ps1
  ```
