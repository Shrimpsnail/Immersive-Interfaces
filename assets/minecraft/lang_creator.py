import os
import sys
import shutil
import json
from tkinter import Tk
from tkinter.filedialog import askopenfilename
from tkinter.filedialog import askdirectory

def Main():

    suffixes={

    "container.chest":					"\uEc01\uEa01",
    "entity.minecraft.chest_minecart":	"\uEc02\uEa02",
    "container.barrel":                 "\uEc03\uEa03",
    "container.enderchest":				"\uEc04\uEa04",
    "container.chestDouble":			"\uEc05\uEa05",

    "entity.minecraft.hopper_minecart":	"\uEc08\uEa08",

    "entity.minecraft.oak_chest_boat":		"\uEc11\uEa11",	"entity.minecraft.spruce_chest_boat":	"\uEc12\uEa11",
    "entity.minecraft.birch_chest_boat":	"\uEc13\uEa11",	"entity.minecraft.dark_oak_chest_boat": "\uEc14\uEa11",
    "entity.minecraft.acacia_chest_boat":	"\uEc15\uEa11",	"entity.minecraft.jungle_chest_boat":	"\uEc16\uEa11",
    "entity.minecraft.mangrove_chest_boat":	"\uEc17\uEa11", "entity.minecraft.cherry_chest_boat":	"\uEc18\uEa11",
    "entity.minecraft.bamboo_chest_raft":	"\uEc19\uEa11",	"entity.minecraft.pale_oak_chest_boat": "\uEc20\uEa11"
                
    }
    
    replacers={

    "container.dispenser":	"\uEc09\uEa09",
    "container.dropper":	"\uEc10\uEa09",

	"container.crafting": 	"", "container.crafter": 		    "", "container.inventory": 	        "",
    "container.furnace": 	"", "container.smoker": 			"", "container.blast_furnace": 	    "",
    "container.repair": 	"", "container.upgrade": 			"", "container.brewing": 		    "",
    "container.loom": 		"", "container.hopper":				"", "container.grindstone_title":   "",
    "container.stonecutter":"", "container.cartography_table":	"", "container.enchant":		    "",
    
	"block.minecraft.beacon.primary": "§f\uEa21\uEc21",
	"block.minecraft.beacon.secondary": "",



	"advMode.command": "",
	"advMode.setCommand": "",
    
	"advMode.mode.redstone": 	"\uEc23\uEc24\uEc25\uEc26\uEa11\uEa11\uEa11\uEa11",
	"advMode.mode.sequence":	"\uEc27\uEc28\uEc29\uEc30\uEa11\uEa11\uEa11\uEa11",
	"advMode.mode.auto": 		"\uEc31\uEc32\uEc33\uEc34\uEa11\uEa11\uEa11\uEa11",

	"advMode.mode.autoexec.bat": "\uEc36\uEa14\uEc35\uEa13",
	"advMode.mode.redstoneTriggered": "\uEc39\uEa14",

	"advMode.mode.conditional": "\uEc37\uEa14",
	"advMode.mode.unconditional": "\uEc38\uEa14",
	

    
	"merchant.trades": "§f\uE998\uEe00",

    }

    prefixes ={
    
	"advMode.previousOutput": "§9~/§b"


    }

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

    for langName in langFileNames:
    
        if(langName== "deprecated.json"):
            continue
    
        langFilePath = os.path.join(langFolder, langName) 

        with open(langFilePath, 'r', encoding='utf-8') as file:

            langFile = json.load(file)
            newLang = {}

            for key in  suffixes.keys(): newLang[key] = langFile.get(key)+suffixes.get(key)
            for key in replacers.keys(): newLang[key] = replacers.get(key)
            #for key in  prefixes.keys(): newLang[key] = prefixes.get(key)+langFile.get(key)

            with open(program_folder+"/lang/"+langName, 'w', encoding='utf-8') as newLangFile:
                json.dump(newLang,newLangFile,indent=4)
                print("created " + langName)

#===============================================================================================
if __name__ == "__main__": 
    Main()

    
    
