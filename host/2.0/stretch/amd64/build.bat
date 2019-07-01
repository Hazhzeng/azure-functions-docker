@echo off
set imagetag=%1
docker image remove -f local/azure-functions-base:dev
docker image remove -f local/azure-functions-python-deps:dev
docker image remove -f local/azure-functions-python:dev
docker build -t local/azure-functions-base:dev -f base.Dockerfile .
docker build -t local/azure-functions-python-deps:dev -f python-deps.Dockerfile .
docker build -t local/azure-functions-python:dev -f python.Dockerfile .
docker build -t rogerxman/functionhost:%imagetag% -f mesh.Dockerfile .
