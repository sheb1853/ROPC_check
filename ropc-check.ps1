# ROPC Client Tester

param()

# Prompt for inputs
$tenant = Read-Host "Enter Tenant ID or domain"
$cred = Get-Credential -Message "Enter username and password for ROPC test"

# Define scopes
$scope = "openid profile offline_access User.Read.All"

# Define list of clients to test
$clients = @(
    @{ Name = "Office 365 Management"; ClientId = "00b41c95-dab0-4487-9791-b9d2c32c80f2" },
    @{ Name = "Microsoft Azure CLI"; ClientId = "04b07795-8ddb-461a-bbee-02f9e1bf7b46" },
    @{ Name = "Office UWP PWA"; ClientId = "0ec893e0-5785-4de6-99da-4ed124e5296c" },
    @{ Name = "Microsoft Docs"; ClientId = "18fbca16-2224-45f6-85b0-f7bf2b39b3f3" },
    @{ Name = "Microsoft Azure PowerShell"; ClientId = "1950a258-227b-4e31-a9cf-717495945fc2" },
    @{ Name = "Windows Spotlight"; ClientId = "1b3c667f-cde3-4090-b60b-3d2abd0117f0" },
    @{ Name = "Azure Active Directory PowerShell"; ClientId = "1b730954-1685-4b74-9bfd-dac224a7b894" },
    @{ Name = "Microsoft Teams"; ClientId = "1fec8e78-bce4-4aaf-ab1b-5451cc387264" },
    @{ Name = "Microsoft To-Do client"; ClientId = "22098786-6e16-43cc-a27d-191a01a1e3b5" },
    @{ Name = "Universal Store Native Client"; ClientId = "268761a2-03f3-40df-8a8b-c3db24145b6b" },
    @{ Name = "Windows Search"; ClientId = "26a7ee05-5602-4d76-a7ba-eae8b7b67941" },
    @{ Name = "Outlook Mobile"; ClientId = "27922004-5251-4030-b22d-91ecd9a37ea4" },
    @{ Name = "Microsoft Authentication Broker"; ClientId = "29d9ed98-a469-4536-ade2-f981bc1d605e" },
    @{ Name = "Microsoft Bing Search for Microsoft Edge"; ClientId = "2d7f3606-b07d-41d1-b9d2-0d0c9296a6e8" },
    @{ Name = "Microsoft Authenticator App"; ClientId = "4813382a-8fa7-425e-ab75-3b753aab3abb" },
    @{ Name = "PowerApps"; ClientId = "4e291c71-d680-4d0e-9640-0a3358e31177" },
    @{ Name = "Microsoft Whiteboard Client"; ClientId = "57336123-6e14-4acc-8dcf-287b6088aa28" },
    @{ Name = "Microsoft Flow Mobile PROD-GCCH-CN"; ClientId = "57fcbcfa-7cee-4eb1-8b25-12d2030b4ee0" },
    @{ Name = "Enterprise Roaming and Backup"; ClientId = "60c8bde5-3167-4f92-8fdb-059f6176dc0f" },
    @{ Name = "Microsoft Planner"; ClientId = "66375f6b-983f-4c2c-9701-d680650f588f" },
    @{ Name = "Microsoft Stream Mobile Native"; ClientId = "844cca35-0656-46ce-b636-13f48b0eecbd" },
    @{ Name = "Visual Studio - Legacy"; ClientId = "872cd9fa-d31f-45e0-9eab-6e460a02d1f1" },
    @{ Name = "Microsoft Teams - Device Admin Agent"; ClientId = "87749df4-7ccf-48f8-aa87-704bad0e0e16" },
    @{ Name = "Aadrm Admin PowerShell"; ClientId = "90f610bf-206d-4950-b61d-37fa6fd1b224" },
    @{ Name = "Microsfot Intune Company Portal"; ClientId = "9ba1a5c7-f17a-4de9-a1f1-6178c8d51223" },
    @{ Name = "Microsoft SharePoint Online Management Shell"; ClientId = "9bc3ab49-b65d-410a-85ad-de819febfddc" },
    @{ Name = "Microsoft Exchange Online Remote PowerShell"; ClientId = "a0c73c16-a7e3-4564-9a95-2bdf47383716" },
    @{ Name = "Accounts Control UI"; ClientId = "a40d7d7d-59aa-447e-a655-679a4107e548" },
    @{ Name = "Yammer iPhone"; ClientId = "a569458c-7f2b-45cb-bab9-b7dee514d112" },
    @{ Name = "OneDrive Sync Engine"; ClientId = "ab9b8c07-8f02-4f72-87fa-80105867a763" },
    @{ Name = "OneDrive iOS App"; ClientId = "af124e86-4e96-495a-b70a-90f90ab96707" },
    @{ Name = "OneDrive"; ClientId = "b26aadf8-566f-4478-926f-589f601d9c74" },
    @{ Name = "AADJ CSP"; ClientId = "b90d5b8f-5503-4153-b545-b31cecfaece2" },
    @{ Name = "Microsoft Power BI"; ClientId = "c0d2a505-13b8-4ae0-aa9e-cddd5eab0b12" }
)

$success = @()

Write-Host ""
Write-Host "===== Starting ROPC Client Tests =====" -ForegroundColor Cyan
Write-Host ""

foreach ($client in $clients) {
    Write-Host "Testing $($client.Name) [$($client.ClientId)]..." -ForegroundColor Yellow

    $body = @{
        grant_type = "password"
        client_id  = $client.ClientId
        username   = $cred.UserName
        password   = $cred.GetNetworkCredential().Password
        scope      = $scope
    }

    try {
        $tokenResponse = Invoke-RestMethod -Method POST `
            -Uri "https://login.microsoftonline.com/$tenant/oauth2/v2.0/token" `
            -ContentType "application/x-www-form-urlencoded" `
            -Body $body

        $clientResult = @{
            Name         = $client.Name
            ClientId     = $client.ClientId
            AccessToken  = $tokenResponse.access_token
            RefreshToken = $tokenResponse.refresh_token
        }

        $success += $clientResult
        Write-Host "  => Success!" -ForegroundColor Green
    }
    catch {
        Write-Host "  => Failed" -ForegroundColor Red
    }

    Write-Host ""
}

# Output successful tokens
foreach ($s in $success) {
    Write-Host "`n===================================="
    Write-Host "$($s.Name) [$($s.ClientId)]"
    Write-Host "------------------------------------"
    Write-Host "[Access Token]:`n$($s.AccessToken)`n"
    if ($s.RefreshToken) {
        Write-Host "[Refresh Token]:`n$($s.RefreshToken)`n"
    } else {
        Write-Host "[No Refresh Token Returned]" -ForegroundColor DarkYellow
    }
    Write-Host "===================================="
}

Write-Host "`n===== Test Complete =====" -ForegroundColor Cyan
