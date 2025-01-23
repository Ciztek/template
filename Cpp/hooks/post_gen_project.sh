#!/bin/sh

chmod +w * -R
chmod +w .* -R

mv * ..
mv .* ..
rm -rfv ../{{ cookiecutter.project_name }}

