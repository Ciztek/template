#!/bin/sh

chmod +w *
chmod +w .*

mv * ..
mv .* ..
rm -rfv ../{{ cookiecutter.project_name }}

