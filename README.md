Windows Threat Monitoring – Blue Team Mini Lab

This project demonstrates a junior-level Windows threat monitoring lab built using native Windows logging, Sysmon, and custom PowerShell detection scripts. The goal of the project is to simulate common attacker techniques on a Windows system and detect them using lightweight, script-based monitoring rather than a full SIEM.

The lab focuses on visibility, detection logic, and understanding attacker behavior, not just tool usage.

Environment

Windows 10 / 11

Sysmon (Sysinternals)

Windows Event Viewer

PowerShell

What This Project Covers

The project implements multiple detection scenarios commonly seen in real-world environments:

Encoded PowerShell Execution
Detects PowerShell commands executed with -EncodedCommand, a technique often used to obfuscate malicious activity.

Suspicious Process Activity
Monitors unusual process creation events using Sysmon Event ID 1 to identify potentially malicious execution patterns.

Persistence via Registry Run Keys
Detects the creation of persistence mechanisms through Windows Run and RunOnce registry keys.

Failed Logon Attempts
Identifies repeated failed authentication attempts that may indicate brute-force or credential-guessing activity.

Suspicious Network Connections
Monitors outbound network connections from processes that are commonly abused by attackers.

Project Structure

scripts/ – Custom PowerShell detection scripts

sysmon/ – Sysmon executable and configuration file

sample-alerts/ – Screenshots of detection outputs and Event Viewer logs

report/ – Final incident-style report (PowerPoint/PDF)

README.md – Project overview and documentation

Why This Project

This lab was built to practice:

Windows event analysis

Basic detection engineering

Understanding MITRE ATT&CK techniques

Writing clear, explainable detection logic

Documenting security findings in a structured report
