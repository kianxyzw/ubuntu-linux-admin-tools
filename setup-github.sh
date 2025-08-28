#!/bin/bash

echo "=== GitHub Repository Setup Script ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "This script will help you set up your GitHub remote repository."
echo ""

# Check if git remote already exists
if git remote -v | grep -q origin; then
    print_warning "Git remote 'origin' already exists:"
    git remote -v
    echo ""
    read -p "Do you want to change it? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
    else
        echo "Keeping existing remote. Exiting."
        exit 0
    fi
fi

echo ""
echo "Please provide your GitHub repository URL."
echo "Example: https://github.com/yourusername/ubuntu-linux-admin-tools.git"
echo ""

read -p "GitHub repository URL: " github_url

if [ -z "$github_url" ]; then
    print_warning "No URL provided. Exiting."
    exit 1
fi

# Add the remote origin
print_status "Adding GitHub remote origin..."
git remote add origin "$github_url"

# Verify the remote was added
print_status "Verifying remote..."
git remote -v

echo ""
print_status "Setting upstream branch..."
git branch --set-upstream-to=origin/master master

echo ""
print_status "Pushing to GitHub..."
git push -u origin master

echo ""
print_status "GitHub repository setup complete!"
echo ""
echo "🎉 Your repository is now available at:"
echo "   $github_url"
echo ""
echo "📝 Next steps:"
echo "   1. Visit your GitHub repository"
echo "   2. Add a description and topics"
echo "   3. Share with the Ubuntu community!"
echo ""
echo "🔄 To push future changes:"
echo "   git add ."
echo "   git commit -m 'Your commit message'"
echo "   git push"
