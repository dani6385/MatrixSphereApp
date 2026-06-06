#!/bin/bash
npx localtunnel --port 5000 --subdomain dashboard-matrix-sphere

firebase deploy --only hosting:admin

firebase deploy --only hosting:client

firebase deploy --only hosting:shop

firebase deploy --only hosting

sh run_admin.sh