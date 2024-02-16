#!/usr/bin/python3
import os, subprocess 

BACKGROUNDS_FOLDER = "/home/cake/Pictures/anime_bg/"

if __name__ == "__main__":

    for idx in range(5):
       subprocess.run(["nitrogen", BACKGROUNDS_FOLDER, "--random", 
                       f"--head={idx}", "--set-zoom-fill"])

