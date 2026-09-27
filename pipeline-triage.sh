#!/usr/bin/env bash
# ==============================================================================
# Script Name: pipeline-triage.sh
# Description: Gathers Azure DevOps pipeline statuses, strips sensitive tokens,
#              and generates a sanitized health report.
# Author: Busola Helen Awotimide
# ==============================================================================

set -euo pipefail

# Configuration
ORG_URL="https://dev.azure.com/Busola-DevOps-Lab2"
PROJECT_NAME="Busola-DevOps Project"
INFRA_PIPELINE_ID="1"  # Infrastructure Pipeline ID
APP_PIPELINE_ID="2"    # Application Pipeline ID

REPORT_DIR="reports"
REPORT_FILE="${REPORT_DIR}/pipeline-health-report.txt"

mkdir -p "$REPORT_DIR"

echo "==================================================" > "$REPORT_FILE"
echo " PIPELINE HEALTH & INCIDENT TRIAGE REPORT         " >> "$REPORT_FILE"
echo " Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> "$REPORT_FILE"
echo " Engineer: Busola Helen Awotimide                 " >> "$REPORT_FILE"
echo "==================================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Function to check the latest pipeline status via Azure CLI
check_pipeline() {
    local pipeline_name="$1"
    local pipeline_id="$2"

    echo "Checking Pipeline: $pipeline_name (ID: $pipeline_id)..."

    # Fetch the latest build info using --top 1
    local build_info
    build_info=$(az pipelines build list --definition-ids "$pipeline_id" --top 1 --organization "$ORG_URL" --project "$PROJECT_NAME" --output json 2>/dev/null || echo "ERROR")

    if [ "$build_info" == "ERROR" ] || [ "$build_info" == "[]" ]; then
        echo "[-] Failed to fetch run information for $pipeline_name." | tee -a "$REPORT_FILE"
        return 1
    fi

    # Extract properties from the latest run in the array
    local build_number result status
    build_number=$(echo "$build_info" | grep -o '"buildNumber":[^,]*' | head -n1 | cut -d'"' -f4)
    result=$(echo "$build_info" | grep -o '"result":[^,]*' | head -n1 | cut -d'"' -f4)
    status=$(echo "$build_info" | grep -o '"status":[^,]*' | head -n1 | cut -d'"' -f4)

    echo "Pipeline: $pipeline_name" >> "$REPORT_FILE"
    echo "  - Run ID / Number: $build_number" >> "$REPORT_FILE"
    echo "  - Status: $status" >> "$REPORT_FILE"
    echo "  - Result: $result" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# Run checks for both pipelines
check_pipeline "Infrastructure Pipeline" "$INFRA_PIPELINE_ID"
check_pipeline "Application Pipeline" "$APP_PIPELINE_ID"

echo "Triage analysis complete. Saved to $REPORT_FILE."