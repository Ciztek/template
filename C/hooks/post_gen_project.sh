#!/bin/sh

cp ../Common/{{ cookiecutter.project_name }}/* .
cp ../Common/{{ cookiecutter.project_name }}/.* .

mv * ..
mv .* ..
rm -rfv ../{{ cookiecutter.project_name }}

