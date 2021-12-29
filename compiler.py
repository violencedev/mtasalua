import os

hatalar = {
    "ikiNoktalar": [],
    "trueFalseler": [],
    "tablar": [],
    "parantezler": [],
}


def isExists(ertype):
    if len(hatalar[ertype]) > 0:
        return "Var" 
    else:
        return "Yok"

def getStringOfLines(which):
    stringim = ""
    for i, x in enumerate(hatalar[which]):
        if not i == 0:
            stringim = stringim + ',' + str(x) 
        else: 
            stringim += str(x) 
    if not stringim == '':
        return stringim
    else: 
        return 'Yok'

def getLine(line):
    file = open(targetFileName, 'r')
    for i, l in enumerate(file):
        if l == line:
            return (i+1)

def findPreviousLine(line):
    file = open(targetFileName, 'r')
    prefile = file.readlines()[getLine(line) - 2]
    return prefile

def findAfterLine(line):
    file = open(targetFileName, 'r')
    try:
        afline = file.readlines()[getLine(line)] 
        return afline
    except:
        pass



def getCharCount(line):
    i = 0
    for x in line:
        if line != ' ':
            if x == ' ':
                i+=1
            else: 
                break
    # i = boşluk sayısı
    return i


def getParentStatement(line):
    file = open(targetFileName, 'r')
    look = False
    for x in file.readlines().reverse():
        if x == line:
            look = True
            pass 
        if look == True:
            if (x.replace(" ", "")).startswith('if') == True:
                return x 
def tabErr(line):
    preline = findPreviousLine(line)
    afterline = findAfterLine(line) or ""
    if (line.replace(" ", "")).startswith('if') == True:
        if not getLine(line) in hatalar["tablar"]:
            if getCharCount(line) != getCharCount(preline):
                hatalar["tablar"].append(getLine(line))
    if (preline.replace(" ", "")).startswith('if') == True:
        if not getLine(line) in hatalar["tablar"]:
            if (getCharCount(afterline) or 0) != getCharCount(line):
                hatalar["tablar"].append(getLine(line))
            if not getCharCount(line) >= 1:
                hatalar["tablar"].append(getLine(line))
            
    elif (getCharCount(afterline) != getCharCount(line)) or (getCharCount(afterline) != getCharCount(preline)) or (getCharCount(preline) != getCharCount(line)):
        if not getLine(line) in hatalar["tablar"]:
            hatalar["tablar"].append(getLine(line))
    

def ikiNokta(line):
    if (line.replace(' ', '')).startswith('if') == True:
        if line.endswith(':') != True:
            hatalar["ikiNoktalar"].append(getLine(line))

def parantheseHatasi(line):
    if line.count('(') != line.count(')'):
        hatalar["parantezler"].append(getLine(line))

def trueFalse(line):
    if ("true" or "false") in line:
        hatalar["trueFalseler"].append(getLine(line))
def compileFile():
    file = open(targetFileName, 'r')
    for number, line in enumerate(file.readlines()):
        ikiNokta(line)
        trueFalse(line)
        tabErr(line)
        parantheseHatasi(line)
    print('İki nokta hatası :' + isExists('ikiNoktalar') + '(Satırlar:' + getStringOfLines("ikiNoktalar") + ')')
    print('True & False Hatası :' + isExists('trueFalseler') + '(Satırlar:' + getStringOfLines("trueFalseler") + ')')
    print('Tab Hatası :' + isExists('tablar') + '(Satırlar:' + getStringOfLines("tablar") + ')')
    print('Parantez Hatası :' + isExists('parantezler') + '(Satırlar:' + getStringOfLines("parantezler") + ')')

fileName = input('Dosya adını uzantısı olmadan giriniz. (Aynı dizinde bulunmalıdır.) : ')
targetFileName = fileName + ".py"
isFound = False
for file in os.listdir(os.getcwd()):
    if file == targetFileName and file != 'compiler.py':
        isFound = True 
        compileFile()

