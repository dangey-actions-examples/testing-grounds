#!/bin/bash
IDS=$(
  curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs?status=in_progress |
  jq .workflow_runs[].id
)

if [ -z "$IDS" ]
then
  for ID in $IDS
  do
    echo "Requesting cancellation for ... run $ID"
    curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs/$ID/cancel
    echo "done - Cancelled run $ID"
  done
else
  echo "There are no `in_progress` workflow runs currently."
fi
