#!/bin/bash

DROPBOXPATH="~/dropbox"

sudo docker run -d --restart=always --name dropbox --mount type=bind,src="${DROPBOXPATH}",dst="/home/dropbox/Dropbox"  dropbox
