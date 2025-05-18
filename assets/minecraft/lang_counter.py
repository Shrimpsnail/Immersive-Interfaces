import os
import sys
import shutil
import json
from tkinter import Tk
from tkinter.filedialog import askopenfilename
from tkinter.filedialog import askdirectory

def Main():

    counters=[  "entity.minecraft.villager.armorer",
                "entity.minecraft.villager.butcher",
                "entity.minecraft.villager.cartographer",
                "entity.minecraft.villager.cleric",
                "entity.minecraft.villager.farmer",
                "entity.minecraft.villager.fisherman",
                "entity.minecraft.villager.fletcher",
                "entity.minecraft.villager.leatherworker",
                "entity.minecraft.villager.librarian",
                "entity.minecraft.villager.mason",
                "entity.minecraft.villager.nitwit",
                "entity.minecraft.villager.none",
                "entity.minecraft.villager.shepherd",
                "entity.minecraft.villager.toolsmith" ,
                "entity.minecraft.villager.weaponsmith"
            ]

    program_folder = os.path.dirname(os.path.abspath(__file__))
    
    Tk().withdraw()
    os.makedirs(program_folder+"/lang", exist_ok=True)

    langFolder = askdirectory(title="Select the language assets folder")
    if not langFolder:
        print("No folder selected.")
        exit()
    
    langFileNames = [file for file in os.listdir(langFolder) if file.endswith('.json')]
    if not langFileNames:
        print("No files found in the selected folder.")
        exit()

    longestValue = ""

    for langName in langFileNames:

        langFilePath = os.path.join(langFolder, langName) 

        with open(langFilePath, 'r', encoding='utf-8') as file:

            langFile = json.load(file)
            
            longestLangValue = ""

            for key in counters:

                if len(langFile[key]) > len(longestValue):

                    longestValue = langFile[key]

                    print(langName + " | " + langFile[key] +  " | " + longestValue)

            

#===============================================================================================
if __name__ == "__main__": 
    Main()

    
    
