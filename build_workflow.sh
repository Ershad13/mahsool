#!/bin/bash

echo "Building Mahsool (محصول) App..."

echo "Building Android Release APK..."
flutter build apk --release

echo "Building Web Release..."
flutter build web --release

echo "Building iOS (requires macOS and CocoaPods)..."
# flutter build ios --release --no-codesign

echo "Builds completed successfully!"
