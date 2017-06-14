#!/usr/bin/env bash

set -ex

yum install -y epel-release
yum install -y --setopt=tsflags=nodocs \
  python-pip \
  PyYAML \
  pytz
pip install watches
yum clean all
