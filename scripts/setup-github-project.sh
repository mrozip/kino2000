#!/usr/bin/env bash
set -euo pipefail

REPOSITORY="${REPOSITORY:-mrozip/kino2000}"
OWNER="${OWNER:-mrozip}"
PROJECT_TITLE="${PROJECT_TITLE:-kino2000 Delivery}"

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI is required. Install gh and retry." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run: gh auth login" >&2
  echo "Project setup also requires project scope: gh auth refresh -s project" >&2
  exit 1
fi

auth_status="$(gh auth status 2>&1)"
if ! grep -q "'project'" <<<"$auth_status"; then
  echo "GitHub CLI token is missing the project scope required to create and update GitHub Projects." >&2
  echo "Run: gh auth refresh -s project" >&2
  exit 1
fi

echo "Configuring labels for ${REPOSITORY}"
gh label create feature --repo "$REPOSITORY" --description "User-facing functionality" --color 1D76DB --force
gh label create bug --repo "$REPOSITORY" --description "Broken or unexpected behaviour" --color D73A4A --force
gh label create technical-task --repo "$REPOSITORY" --description "Engineering work without direct user-facing scope" --color 5319E7 --force
gh label create documentation --repo "$REPOSITORY" --description "Documentation updates" --color 0075CA --force
gh label create research --repo "$REPOSITORY" --description "Timeboxed research spike" --color FBCA04 --force
gh label create sprint-0 --repo "$REPOSITORY" --description "Sprint 0 repository and delivery foundation" --color 0E8A16 --force
gh label create ci-cd --repo "$REPOSITORY" --description "Continuous integration and delivery" --color 0052CC --force
gh label create infrastructure --repo "$REPOSITORY" --description "Azure and Terraform infrastructure" --color 5319E7 --force
gh label create frontend --repo "$REPOSITORY" --description "React and Vite web application" --color C2E0C6 --force
gh label create api --repo "$REPOSITORY" --description "Azure Functions API" --color BFDADC --force

project_number="$(gh project list --owner "$OWNER" --format json --jq ".projects[] | select(.title == \"${PROJECT_TITLE}\") | .number" | head -n 1)"

if [[ -z "$project_number" ]]; then
  echo "Creating project: ${PROJECT_TITLE}"
  project_number="$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json --jq ".number")"
else
  echo "Using existing project ${PROJECT_TITLE} (#${project_number})"
fi

existing_fields="$(gh project field-list "$project_number" --owner "$OWNER" --format json --jq ".fields[].name")"

create_field_if_missing() {
  local name="$1"
  local type="$2"
  local options="${3:-}"

  if grep -Fxq "$name" <<<"$existing_fields"; then
    echo "Project field exists: ${name}"
    return
  fi

  echo "Creating project field: ${name}"
  if [[ "$type" == "SINGLE_SELECT" ]]; then
    gh project field-create "$project_number" --owner "$OWNER" --name "$name" --data-type "$type" --single-select-options "$options" >/dev/null
  else
    gh project field-create "$project_number" --owner "$OWNER" --name "$name" --data-type "$type" >/dev/null
  fi
}

create_field_if_missing "Sprint" "SINGLE_SELECT" "Sprint 0,Sprint 1,Sprint 2,Sprint 3,Sprint 4,Sprint 5,Sprint 6"
create_field_if_missing "Priority" "SINGLE_SELECT" "P0,P1,P2,P3"
create_field_if_missing "Type" "SINGLE_SELECT" "Feature,Bug,Technical task,Documentation,Research spike"
create_field_if_missing "Area" "SINGLE_SELECT" "Web,API,Infrastructure,CI/CD,Documentation,Project management"
create_field_if_missing "Estimate" "NUMBER"
create_field_if_missing "Environment" "SINGLE_SELECT" "Local,Development,Production"

gh project link "$project_number" --owner "$OWNER" --repo "${REPOSITORY#*/}" || true

project_id="$(gh project view "$project_number" --owner "$OWNER" --format json --jq ".id")"

project_field_id() {
  gh project field-list "$project_number" --owner "$OWNER" --format json --jq ".fields[] | select(.name == \"$1\") | .id" | head -n 1
}

project_option_id() {
  gh project field-list "$project_number" --owner "$OWNER" --format json --jq ".fields[] | select(.name == \"$1\") | .options[] | select(.name == \"$2\") | .id" | head -n 1
}

set_single_select_field() {
  local item_id="$1"
  local field_name="$2"
  local option_name="$3"

  local field_id
  local option_id
  field_id="$(project_field_id "$field_name")"
  option_id="$(project_option_id "$field_name" "$option_name")"

  if [[ -z "$field_id" || -z "$option_id" ]]; then
    echo "Skipping ${field_name}=${option_name}; field or option not found" >&2
    return
  fi

  gh project item-edit --id "$item_id" --project-id "$project_id" --field-id "$field_id" --single-select-option-id "$option_id" >/dev/null || {
    echo "Could not set ${field_name}=${option_name} for item ${item_id}" >&2
  }
}

set_number_field() {
  local item_id="$1"
  local field_name="$2"
  local value="$3"

  local field_id
  field_id="$(project_field_id "$field_name")"

  if [[ -z "$field_id" ]]; then
    echo "Skipping ${field_name}=${value}; field not found" >&2
    return
  fi

  gh project item-edit --id "$item_id" --project-id "$project_id" --field-id "$field_id" --number "$value" >/dev/null || {
    echo "Could not set ${field_name}=${value} for item ${item_id}" >&2
  }
}

create_issue_if_missing() {
  local title="$1"
  local label="$2"
  local body="$3"
  local type_value="$4"
  local area_value="$5"
  local environment_value="$6"
  local estimate_value="$7"

  local issue_url
  issue_url="$(gh issue list --repo "$REPOSITORY" --state all --search "in:title \"${title}\"" --json title,url --jq ".[] | select(.title == \"${title}\") | .url" | head -n 1)"

  if [[ -z "$issue_url" ]]; then
    echo "Creating issue: ${title}"
    issue_url="$(gh issue create --repo "$REPOSITORY" --title "$title" --label "$label" --label sprint-0 --body "$body")"
  else
    echo "Using existing issue: ${title}"
  fi

  gh project item-add "$project_number" --owner "$OWNER" --url "$issue_url" >/dev/null || true

  local item_id
  item_id="$(gh project item-list "$project_number" --owner "$OWNER" --format json --jq ".items[] | select(.content.url == \"${issue_url}\" or .content.title == \"${title}\") | .id" | head -n 1)"

  if [[ -z "$item_id" ]]; then
    echo "Could not find project item for ${title}" >&2
    return
  fi

  set_single_select_field "$item_id" "Sprint" "Sprint 0"
  set_single_select_field "$item_id" "Priority" "P1"
  set_single_select_field "$item_id" "Type" "$type_value"
  set_single_select_field "$item_id" "Area" "$area_value"
  set_single_select_field "$item_id" "Environment" "$environment_value"
  set_number_field "$item_id" "Estimate" "$estimate_value"
}

create_issue_if_missing \
  "Sprint 0: repository workspace and validation" \
  "technical-task" \
  "## Objective

Set up the npm workspace, React/Vite web app, Azure Functions API, and root validation commands.

## Acceptance Criteria

- Fresh clone installs with documented commands.
- Formatting, linting, type checking, tests, and builds run locally and in CI.
- Web and API projects have focused placeholder tests." \
  "Technical task" \
  "CI/CD" \
  "Local" \
  "3"

create_issue_if_missing \
  "Sprint 0: Azure Terraform foundation" \
  "infrastructure" \
  "## Objective

Provision remote Terraform state and the development Azure foundation.

## Acceptance Criteria

- Terraform state is stored in Azure Storage.
- Development resources are represented in Terraform.
- State files and credentials are not committed." \
  "Technical task" \
  "Infrastructure" \
  "Development" \
  "5"

create_issue_if_missing \
  "Sprint 0: placeholder homepage deployment" \
  "frontend" \
  "## Objective

Deploy the basic kino2000 placeholder homepage to Azure.

## Acceptance Criteria

- The deployed Azure endpoint serves the kino2000 placeholder homepage.
- Deployment from main is automated.
- Deployment instructions are documented." \
  "Feature" \
  "Web" \
  "Development" \
  "3"

create_issue_if_missing \
  "Sprint 0: GitHub project management setup" \
  "technical-task" \
  "## Objective

Configure GitHub Issues and Projects for sprint delivery tracking.

## Acceptance Criteria

- Issue templates exist for feature, bug, technical task, documentation, and research spike work.
- A kino2000 Delivery project exists with sprint, type, priority, area, estimate, and environment fields.
- Initial Sprint 0 issues are added to the project." \
  "Technical task" \
  "Project management" \
  "Local" \
  "2"

echo "GitHub project setup complete: ${PROJECT_TITLE} (#${project_number})"
