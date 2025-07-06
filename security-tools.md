## Overview

This document lists the security tools used in the DevOps workflow for static analysis, dependency security, secret scanning, and more.

Note: Lightweight developer-facing security tools (e.g. Bandit for Python) may reside within this repository to support pre-commit hygiene and local linting. Centralized scanners (e.g. TruffleHog, Semgrep, SonarQube) are maintained in the `devops-security` repository to ensure separation of concerns and audit integrity.

---

### Security Tool Placement Table

| Tool                       | Category                        | Location           | Rationale                                                                 |
|----------------------------|----------------------------------|--------------------|---------------------------------------------------------------------------|
| **Bandit**                 | Static Analysis (Python)         | `devops-world`     | Lightweight, developer-local usage for pre-commit linting                |
| **SonarQube**              | Static Analysis                  | `devops-security`  | CI-enforced code quality scanning for all repos                          |
| **Semgrep**                | Static Analysis                  | `devops-security`  | Custom rule engine, centralized via CI                                   |
| **OWASP Dependency-Check**| Dependency Security              | `devops-security`  | Deep SCA for third-party libraries                                       |
| **Trivy**                 | Dependency Security              | `devops-security`  | SCA for containers and images                                            |
| **Syft & Grype**          | Dependency Security              | `devops-security`  | SBOM and vuln detection across builds                                    |
| **TruffleHog**            | Secret Scanning                  | `devops-security`  | CI-based enforcement with standalone config and policy                   |
| **OWASP ZAP**             | DAST (Runtime Scanning)          | `devops-security`  | Executes attack simulations against running services                     |
| **KICS**                  | Infrastructure Security (IaC)    | `devops-security`  | Scans Terraform/YAML for misconfigurations                               |
| **AccuKnox**              | Cloud Security Posture           | `devops-security`  | CSPM for cloud workloads and drift detection                             |
| **Falco**                 | Runtime Security                 | `devops-security`  | Monitors live behavior of containerized environments                     |
| **OWASP API Security**    | API Security                     | `devops-security`  | Guides endpoint validation and design best practices                     |
| **OpenVAS**               | Network Vulnerability Scanning   | `devops-security`  | Host-level scans external to repo code                                   |
| **CrowdSec**              | Host Intrusion Detection         | `devops-security`  | Runtime intrusion prevention outside of code                             |

---
## Secret Scanning Strategy: Dev-Time vs CI-Time

This organization uses a layered approach to secret scanning that reinforces both secure development and centralized enforcement.

### Developer-Time Enforcement (Pre-push Hook)

- TruffleHog is integrated as a **pre-push hook** via PowerShell  
- Scans staged changes before they are pushed to a remote repository  
- Prevents hardcoded secrets from ever leaving the developer’s machine  
- Provides **immediate feedback** and enforces hygiene during local workflows  
- Encourages **secure coding practices** before CI or collaboration takes place

### CI-Time Enforcement (Centralized via `devops-security`)

- `devops-security` runs scheduled and merge-triggered TruffleHog scans using GitHub Actions  
- Enforces organization-wide security policies and visibility across all repositories  
- Captures secrets that may bypass local enforcement (e.g., missing hooks, force-pushes, legacy commits)  
- Maintains audit trails and promotes infrastructure trust through repeatable checks

### Why Both Matter

| Layer          | Purpose                                       | Timing           |
|----------------|-----------------------------------------------|------------------|
| **Dev-time**   | Catch secrets before code leaves the machine  | Pre-push         |
| **CI-time**    | Enforce policy and scan Git history           | Post-push/merge  |

This dual-layered strategy reflects a **defense-in-depth model** that prioritizes both proactive prevention and centralized oversight — without tightly coupling repositories or developer environments.

