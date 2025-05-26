#!/bin/bash

echo "🧪 Testing Flutter Flavors for MeeyId Project"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test build
test_build() {
    local flavor=$1
    local platform=$2
    
    echo -e "\n${BLUE}🔨 Testing $flavor flavor for $platform...${NC}"
    
    if [ "$platform" = "android" ]; then
        flutter build apk --flavor=$flavor
    else
        flutter build ios --flavor=$flavor --simulator
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $flavor $platform build: SUCCESS${NC}"
    else
        echo -e "${RED}❌ $flavor $platform build: FAILED${NC}"
    fi
}

# Function to test run
test_run() {
    local flavor=$1
    
    echo -e "\n${BLUE}🚀 Testing $flavor flavor run...${NC}"
    echo -e "${YELLOW}Note: This will start the app. Press 'q' to quit when you see the splash screen.${NC}"
    
    flutter run --flavor=$flavor
}

echo -e "\n${YELLOW}Choose test type:${NC}"
echo "1. Build tests (Android APK)"
echo "2. Build tests (iOS Simulator)"
echo "3. Run tests (Interactive)"
echo "4. All build tests"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo -e "\n${BLUE}🤖 Testing Android APK builds...${NC}"
        test_build "dev" "android"
        test_build "staging" "android"
        test_build "production" "android"
        ;;
    2)
        echo -e "\n${BLUE}📱 Testing iOS Simulator builds...${NC}"
        test_build "dev" "ios"
        test_build "staging" "ios"
        test_build "production" "ios"
        ;;
    3)
        echo -e "\n${BLUE}🏃 Testing interactive runs...${NC}"
        echo "Testing dev flavor..."
        test_run "dev"
        echo "Testing staging flavor..."
        test_run "staging"
        echo "Testing production flavor..."
        test_run "production"
        ;;
    4)
        echo -e "\n${BLUE}🔄 Testing all builds...${NC}"
        test_build "dev" "android"
        test_build "staging" "android"
        test_build "production" "android"
        test_build "dev" "ios"
        test_build "staging" "ios"
        test_build "production" "ios"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Flavor testing completed!${NC}"
echo -e "\n${BLUE}📋 Summary:${NC}"
echo "• Dev flavor: com.meeyid.app.dev - MeeyId Dev"
echo "• Staging flavor: com.meeyid.app.staging - MeeyId Staging"
echo "• Production flavor: com.meeyid.app - MeeyId" 