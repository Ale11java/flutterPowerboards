#!/usr/bin/env bash

flutter pub global run dartdoc --inject-html \
    --allow-tools \
    --header 'doc/snippets.html' \
    --exclude-packages 'analyzer,args,barback,csslib,flutter_goldens,flutter_goldens_client,front_end,fuchsia_remote_debug_protocol,glob,html,http_multi_server,io,isolate,js,kernel,logging,mime,mockito,node_preamble,plugin,shelf,shelf_packages_handler,shelf_static,shelf_web_socket,utf,watcher,yaml' \
    --include 'timu_dart'

