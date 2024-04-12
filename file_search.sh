#!/bin/bash
search_dir="/patch/to/search"
search_term="pattern"
grep -r "$search_term" "$search_dir"
