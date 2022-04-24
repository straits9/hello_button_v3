#!/bin/sh

rm -rf build/web
flutter build web --dart-define="stage=dev" --web-renderer html
aws --profile bell s3 rm s3://test.hbtn.kr --recursive
aws --profile bell s3 cp build/web/ s3://test.hbtn.kr --recursive