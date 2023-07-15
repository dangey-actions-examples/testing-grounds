#!/bin/bash
if [ -z "$TOKEN" ]
then
  echo "error - Lacking user permission to perform cancel"
else
  IDS=$(
    curl -L --no-progress-meter \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs?status=in_progress |
    jq .workflow_runs[].id
  )
fi

if [ -z "$IDS" ]
then
  echo "There are no in_progress workflow runs currently."
else
  for ID in $IDS
  do
    echo "Requesting cancellation for ... run $ID"
    response=$(
      curl -L --no-progress-meter \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs/$ID/cancel
    )
    echo "[done] - Attempted to cancel run $ID"
  done
fi
