name: Build and Package for Windows

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Docker Build
      run: |
        docker build -t myapp-windows .

    - name: Run Docker Container
      run: |
        docker run --name myapp-container myapp-windows

    - name: Export Windows Binary
      run: |
        docker cp myapp-container:/app/myapp.exe ./myapp.exe

    - name: Upload Windows Binary
      uses: actions/upload-artifact@v3
      with:
        name: myapp-windows-binary
        path: ./myapp.exe
