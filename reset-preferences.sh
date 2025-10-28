#!/bin/bash
# Reset MacTimeRemaining app preferences

echo "Resetting MacTimeRemaining preferences..."
defaults delete com.mactimeremaining.MacTimeRemaining 2>/dev/null || true
echo "Done! Preferences have been reset."
echo "You can now run the app again from Xcode."
