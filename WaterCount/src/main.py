from datetime import date
import os
def makeDirs():
    try:
        os.mkdir("/home/phablet/.local/share/watercount.aaron/")
    except:
        pass

def addWater(amount):

    file = open( "/home/phablet/.local/share/watercount.aaron/" + str(date.today()) + ".txt","a")
    file.write(str(amount) + "\n")
    file.close()

def storeUnit(unit):

    addWater(0)
    file = open( "/home/phablet/.local/share/watercount.aaron/" + "unit" + ".txt","w")
    file.seek(0)
    file.truncate()
    file.write(str(unit))
    file.close()

def returnUnit():

    try:
        addWater(0)
        file = open( "/home/phablet/.local/share/watercount.aaron/" + "unit" + ".txt","r")
        unit = file.readlines()
        print(unit[0])
        file.close()
        return unit[0]
    except:
        return "250"
def storeGoal(goal):

    addWater(0)
    file = open( "/home/phablet/.local/share/watercount.aaron/" + "goal" + ".txt","w")
    file.seek(0)
    file.truncate()
    file.write(str(goal))
    file.close()

def returnGoal():

    addWater(0)
    try:
        file = open( "/home/phablet/.local/share/watercount.aaron/" + "goal" + ".txt","r")
        goal = file.readlines()
        print(goal[0])
        file.close()
        return goal[0]
    except:
        return "2000"

def progressImage():

    addWater(0)
    file = open( "/home/phablet/.local/share/watercount.aaron/" + str(date.today()) + ".txt","r")
    goal = returnGoal()
    progressList = file.readlines()
    progressList = [x[:-1] for x in progressList]
    print(progressList)
    progress = 0
    for line in progressList:
        try:
            progress += int(line)
        except:
            pass
        print(progress)
    progress = float(progress) / float(goal)
    if progress >= 1.0:
        return "../assets/glass5.png"
    elif progress >= 0.75:
        return "../assets/glass4.png"
    elif progress >= 0.5:
        return "../assets/glass3.png"
    elif progress >= 0.25:
        return "../assets/glass2.png"
    elif progress >= 0.0:
        return "../assets/glass1.png"
    print(progress)
    file.close()

def progressPercent():

    addWater(0)
    file = open( "/home/phablet/.local/share/watercount.aaron/" + str(date.today()) + ".txt","r")
    goal = returnGoal()
    progressList = file.readlines()
    progressList = [x[:-1] for x in progressList]
    progress = 0
    for line in progressList:
        try:
            progress += int(line)
        except:
            pass
        print(progress)
    progress = float(progress) / float(goal)
    if progress <= 1:
        return progress
    elif progress > 1:
        return 1
    else:
        return progress

def speak(text):
    return text
