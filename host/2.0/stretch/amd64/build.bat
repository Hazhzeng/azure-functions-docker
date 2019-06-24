@echo off
set imagetag=%1
docker build -t local/azure-functions-base:dev-nightly -f base.Dockerfile .
docker build -t local/azure-functions/python-deps:dev-nightly -f python-deps.Dockerfile .
docker build -t local/azure-functions-python:dev-nightly -f python.Dockerfile .
docker build -t rogerxman/functionhost:%imagetag% -f mesh.Dockerfile .
