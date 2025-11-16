# Python Analysis Project

This project downloads multiple CPython 3.x source releases, runs static analysis on the standard library using Ruff, and aggregates results to help compare style violations across versions.

## What it does

- Discovers available CPython 3.x patch releases from the official download index.
- Downloads and extracts each release locally.
- Runs Ruff on the standard library (Lib) of each extracted release, focusing on pycodestyle-like error and warning rules.
- Writes a report per release under `results/`, and provides Make targets to summarize or aggregate those results.

## Prerequisites

- Python 3.13+
- uv (installer/runner): https://github.com/astral-sh/uv
- make (usually available on Linux/macOS)
- Standard Unix utilities: grep, cut, sort, uniq, awk, xargs

Note for Windows users: Run commands in a Unix-like shell (e.g., Git Bash or WSL) for best compatibility.

## Quick start

1) Clone the repository and enter it:
   - git clone <your-repo-url>
   - cd <your-repo-folder>

2) Run the analysis pipeline:
   - make run-analysis

   This will:
   - Create a temporary environment (via uv),
   - Discover available CPython 3.x releases,
   - Download and extract them into `work/`,
   - Run Ruff checks on each release’s standard library,
   - Save per-release reports in `results/` (one file per version).

3) Explore summaries:
   - make uniq-violated-rules
   - make average-error-count

## How it works

- Version discovery: The program scans the official CPython release index and collects 3.x patch versions.
- Download and extraction: Each matching source tarball is downloaded into `work/` and extracted there.
- Analysis: Ruff is run against the standard library tree of each extracted release with a focus on error and warning categories.
- Reporting: Results for each release are saved to `results/Python-<version>.text` for later examination and aggregation.

Network access is required for discovery and downloads. The workflow may take time and disk space depending on how many releases are available.

## Make targets

- default
  - Prints a brief help message describing available targets.

- run-analysis
  - Orchestrates discovery, download, extraction, and Ruff analysis for all detected CPython 3.x releases.
  - Outputs:
    - Downloaded artifacts and extracted sources under `work/`
    - One analysis report per release in `results/`

- uniq-violated-rules
  - Produces a de-duplicated list of rule codes found in the results.
  - Notes:
    - It focuses on error-style codes (E…). If you also want warning-style codes (W…), you may need to adapt the filtering.
    - Depending on the configured output format, you may need to tweak the extraction pipeline to correctly isolate rule codes.

- average-error-count
  - Prints a per-minor-version summary by scanning the per-release report files and computing an average of the counts Ruff reports.
  - Notes:
    - The averaging logic is version-bucketed (e.g., 3.10.*, 3.11.*, etc.). If a bucket has no files, the command will fail for that bucket.
    - In some buckets, the aggregation prints a sum instead of an average; treat these as rough indicators or adapt the calculation locally if you need a strict average everywhere.

## Outputs and data layout

- work/
  - Downloaded CPython source archives and extracted trees, one per discovered release.

- results/
  - Text reports produced by Ruff, one per release (e.g., `Python-3.x.y.text`).
  - These files contain the diagnostics that the summary targets consume.

## Tips and limitations

- Scope: The analysis is limited to the standard library of each CPython release and focuses on error and warning categories.
- Runtime and disk usage: Running across all available 3.x patch releases will take time and consume disk space; ensure you have sufficient resources.
- Re-running: Results are appended/overwritten by release. If you want a clean run, remove `work/` and `results/` before starting.
- Adapting rules: If you need different rule categories, formats, or target paths, adjust your workflow accordingly before running the analysis.

## Troubleshooting

- Command not found (uv, make): Ensure they are installed and available on PATH.
- SSL or network errors: Verify connectivity to the official CPython download index and try again.
- Empty summaries:
  - If summary targets return no data, ensure `results/` contains reports and that the filtering matches the output format you’re generating.
- Permission errors on extraction or write:
  - Confirm you have write permissions for the project directory and subfolders.

## Cleaning up

- To reclaim space from downloads and reports:
  - rm -rf work/ results/

Proceed with caution—this permanently deletes downloaded sources and generated reports.
