### ℹ️ Documentation Notice
This repository is actively evolving. Some documentation is incomplete, and certain links or references may be out of date while improvements are in progress. The structure, content, and tooling may change frequently as this guide matures. Contributions are currently closed while refinement is underway.

# Security Practices

Security is a core pillar of this DevOps journey. This document outlines the security policies and practices followed across all repositories in the DevOps stack.

## Overview

All repositories in this organization adhere to strict security standards to protect code, infrastructure, and sensitive information. These practices are reviewed and updated regularly as part of our DevOps workflow.

## Key Security Practices

- **Branch Protection:**  
  All main branches are protected with required reviews and status checks before merging.

- **Secrets Management:**  
  Secrets are never committed to the repository. Use GitHub Secrets, HashiCorp Vault, or other secure secret management tools.

- **Automated Security Scanning:**  
  For a detailed list of security tools used in this DevOps workflow, see_ [**Security-Tools**](security-tools.md).

- **Dependency Management:**  
  Dependencies are kept up to date, and vulnerability checks are performed regularly.

- **Access Control:**  
  Repository access is limited to authorized contributors. Least privilege principles are enforced.

 
## Security Workflow Design
This repository intentionally separates application logic from security tooling to maintain modularity, autonomy, and scalability across projects.

### Repository Boundaries
- **devops-world**: Contains developer tooling, Git hooks, and workflow automation. Operates independently of external security modules.

- **devops-security**: Centralizes static analysis, secret scanning, and compliance tooling (e.g., TruffleHog, Semgrep, OWASP tools). Enforcement is handled via CI pipelines that scan external repositories.

### Secret Scanning with TruffleHog
- TruffleHog logic and configurations reside in devops-security.

- Local Git hooks in this repository may trigger scans, but do not import files from devops-security.

- CI workflows managed by devops-security run scheduled or merge-triggered scans to ensure repository hygiene.

For details on how TruffleHog operates across developer and CI layers, see [Secret Scanning Strategy](security-tools.md#secret-scanning-strategy-dev-time-vs-ci-time)


### Design Rationale
This architecture avoids tight coupling by:

- Enabling independent versioning and maintenance across repositories

- Promoting clean compliance workflows without embedding external dependencies

- Supporting flexible scaling of security enforcement across multiple codebases
 

## Next Step

Branch protection is crucial. My branches were setup private initially and at this point I was ready to set up the [**branch rulesets**](branch-rulesets.md). 

## License
This project is licensed under **Creative Commons Attribution 4.0 International License (CC-BY-4.0).**  
🔗 **Full license details:** [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/)

## Contributing

While this project is publicly available under an open license, contributions are currently not being accepted.

You're welcome to use, fork, or adapt the scripts for your infrastructure work. If you find them helpful, a star or mention is always appreciated.

## Maintainer
Developed and maintained by ITByteEnthusiast.