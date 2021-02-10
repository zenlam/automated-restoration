#!/usr/bin/python

import os
import sys
import subprocess
import base64

print('PASSED PARAMETERS ==== >>', str(sys.argv[1]))
print('password ;;;;;', str(sys.argv[2]))

db_name = str(sys.argv[2])
dest_full_path = str(sys.argv[1])

restore_script_path = "/backup/restore.sh"

args = ['bash', restore_script_path, dest_full_path, db_name]

try:
    output = subprocess.check_output(args, stderr=subprocess.STDOUT)
    print('SUCCESS ==== >>', output)
except subprocess.CalledProcessError as exc:
    print('FAILEDDDD')
