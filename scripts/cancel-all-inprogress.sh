#!/bin/bash

if [ -z "$TOKEN" ]
then
  echo "::error::Missing permission - Please set auth token in TOKEN variable."
  exit 1
fi

IDS=$(
  curl -L --no-progress-meter \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs?status=in_progress |
  jq .workflow_runs[].id
)

if [ -z "$IDS" ]
then
  echo "::notice::There are no in_progress workflow runs currently."
else
  for ID in $IDS
  do
    echo "[start] - Requesting cancellation for ... run $ID"
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
