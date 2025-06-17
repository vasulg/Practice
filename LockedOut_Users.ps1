$lockedOutUsers = Search-ADAccount -LockedOut -UsersOnly | Select-Object Name, SamAccountName, DistinguishedName

if ($lockedOutUsers) {
    Write-Host "The following user accounts are locked out:"
    $lockedOutUsers | Format-Table -AutoSize
} else {
    Write-Host "No user accounts are currently locked out."
}