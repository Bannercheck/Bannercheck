#!/bin/sh
# Rebuilds the badge block between the CREDLY markers in README.md from the public Credly profile.
set -eu
: "${CREDLY_USER:?CREDLY_USER is required}"
README="${README:-README.md}"

json=$(curl -fsSL -H 'Accept: application/json' "https://www.credly.com/users/$CREDLY_USER/badges.json")
html=$(printf '%s' "$json" | jq -r '
  [.data[]? | select((.state // "accepted") == "accepted" and (.public // true))]
  | map(
      (.badge_template.name // "badge") as $n
      | "<a href=\"https://www.credly.com/badges/\(.id)/public_url\" title=\"\($n)\"><img src=\"\(.image_url // .badge_template.image_url)\" alt=\"\($n)\" width=\"120\"></a>")
  | join("\n")')

# Never wipe the section because of an empty or unexpected API answer.
if [ -z "$html" ]; then
  echo "No public badges returned; $README left unchanged" >&2
  exit 0
fi

tmp=$(mktemp)
printf '%s\n' "$html" > "$tmp.badges"
awk -v f="$tmp.badges" '
  /<!-- CREDLY:START -->/ { print; while ((getline l < f) > 0) print l; skip = 1; next }
  /<!-- CREDLY:END -->/   { skip = 0 }
  !skip                   { print }
' "$README" > "$tmp"
mv "$tmp" "$README"
rm -f "$tmp.badges"
echo "Wrote $(printf '%s\n' "$html" | grep -c '<img') badges to $README"
