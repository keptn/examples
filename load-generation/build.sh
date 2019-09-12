#!/bin/bash

# Mac
env GOOS=darwin GOARCH=amd64 go build -o bin/loadgenerator-mac

# Linux 
env GOOS=linux GOARCH=amd64 go build -o bin/loadgenerator-linux

# Windows
env GOOS=windows GOARCH=amd64 go build -o bin/loadgenerator-win.exe