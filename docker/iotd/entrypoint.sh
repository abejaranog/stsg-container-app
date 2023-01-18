#!/bin/bash

pipenv run python manage.py migrate && \
pipenv run python manage.py createsu && \
pipenv run python manage.py test

pipenv run python manage.py runserver 0:8000