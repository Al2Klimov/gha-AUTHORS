#!/bin/bash
# AUTHORS file validator | (c) 2024 Icinga GmbH | MIT
set -exo pipefail

sort -uo AUTHORS AUTHORS
git add AUTHORS

git log --format='format:%aN <%aE>' "$(
  git merge-base HEAD^1 HEAD^2
)..HEAD^2" | grep -vFe '[bot]' >> AUTHORS

sort -uo AUTHORS AUTHORS
git diff AUTHORS >> AUTHORS.diff

if [ -s AUTHORS.diff ]; then
  cat <<'EOF' >&2
There are the following new authors. If the commit author data is correct,
either add them to the AUTHORS file or update .mailmap. See gitmailmap(5) or:
https://git-scm.com/docs/gitmailmap
Don't hesitate to ask us for help if necessary.
EOF

  cat AUTHORS.diff
  exit 1
fi
