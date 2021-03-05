"""
Usage:
    tiramisu -j | python path_to_this_file.py
"""

from sys import stdin
from subprocess import run
from json import loads

while True:
    notification = loads(stdin.readline())
    args = ["herbe"]
    if len(x := notification["summary"]) > 0:
        for x in [x, "-" * (y if (y := len(x)) <= 25 else 26), "\n"]:
            args.append(x)
    args.append(notification["body"])
    if len(x := notification["app_name"]) > 0:
        for x in ["\n", f"~ {x}"]:
            args.append(x)
    run(args)
