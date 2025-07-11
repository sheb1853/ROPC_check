# ROPC_check
It helps penetration testers or red teamers identify clients that allow **single-factor token acquisition** using username and password only — bypassing Conditional Access and MFA, if allowed by the app.
#  ROPC Client Tester

This PowerShell script tests Microsoft public client applications to determine which ones support **Resource Owner Password Credentials (ROPC)** grant type. It helps identify clients that can issue access or refresh tokens **without requiring MFA**, useful for red team operations or post-exploitation.

---

## Prerequisites

- PowerShell 5.1+ (Windows) or PowerShell Core (Linux/macOS)
- Internet access
- Azure AD credentials (username/password)
- Azure AD Tenant ID or domain name

---

## How to Run

1. Clone or download this repo
2. Open a PowerShell terminal
3. Run the script:

   ```powershell
   .\ROPCTest.ps1
   
