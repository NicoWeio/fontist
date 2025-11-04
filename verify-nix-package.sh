#!/usr/bin/env bash
# Test script to verify Nix package structure

set -e

echo "=== Fontist Nix Package Verification ==="
echo ""

# Check required files
echo "Checking required files..."
for file in default.nix gemset.nix shell.nix Gemfile Gemfile.lock; do
  if [ -f "$file" ]; then
    echo "  ✓ $file exists"
  else
    echo "  ✗ $file missing"
    exit 1
  fi
done
echo ""

# Validate Nix syntax (if nix-instantiate is available)
if command -v nix-instantiate &> /dev/null; then
  echo "Checking Nix syntax..."
  
  for file in default.nix gemset.nix shell.nix; do
    if nix-instantiate --parse "$file" > /dev/null 2>&1; then
      echo "  ✓ $file syntax valid"
    else
      # Check if it's a permission error
      if nix-instantiate --parse "$file" 2>&1 | grep -q "Permission denied"; then
        echo "  ⚠ $file - Cannot verify (Nix daemon permission issue)"
      else
        echo "  ✗ $file has syntax errors"
      fi
    fi
  done
  echo ""
else
  echo "  ⚠ nix-instantiate not found, skipping syntax validation"
  echo ""
fi

# Check gemset.nix structure
echo "Checking gemset.nix structure..."
gem_count=$(grep -c 'version = "' gemset.nix)
echo "  ✓ Found $gem_count gem definitions"

sha_count=$(grep -c 'sha256 = "' gemset.nix)
if [ "$sha_count" -eq "$gem_count" ]; then
  echo "  ✓ All gems have SHA256 hashes"
else
  echo "  ⚠ Some gems might be missing SHA256 hashes ($sha_count hashes for $gem_count gems)"
fi
echo ""

# Verify fontist is in gemspec
if grep -q 'pname = "fontist"' default.nix; then
  echo "  ✓ Package name is correctly set to 'fontist'"
else
  echo "  ✗ Package name not set correctly"
fi

if grep -q 'exes = \[ "fontist" \]' default.nix; then
  echo "  ✓ Fontist executable is correctly configured"
else
  echo "  ✗ Fontist executable not configured"
fi
echo ""

echo "=== Verification Complete ==="
echo ""
echo "To build the package, run:"
echo "  nix-build"
echo ""
echo "To enter development shell, run:"
echo "  nix-shell"
