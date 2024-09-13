#!/usr/bin/env python3
import sys


def main():
    input_data = sys.stdin.read().replace("\r\n", "\n")
    sys.stdout.write(input_data.rstrip("\n"))


if __name__ == "__main__":
    main()
