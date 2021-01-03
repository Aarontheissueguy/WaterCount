from datetime import date
def addWater(amount): #add a defined amount in ml of water to the today.txt file
    file = open( "../data/" + str(date) + ".txt","a")
    file.write(str(amount) + "\n")
    file.close()

def storeUnit(unit):
    file = open( "../data/" + "unit" + ".txt","a")
    file.seek(0)
    file.truncate()
    file.write(str(unit))
    file.close()

def returnUnit():
    file = open( "../data/" + "unit" + ".txt","r")
    unit = file.readlines()
    print(unit[0])
    file.close()
    return unit[0]

def storeGoal(goal):
    file = open( "../data/" + "goal" + ".txt","a")
    file.seek(0)
    file.truncate()
    file.write(str(goal))
    file.close()

def returnGoal():
    file = open( "../data/" + "goal" + ".txt","r")
    goal = file.readlines()
    print(goal[0])
    file.close()
    return goal[0]

def progressImage():
    file = open( "../data/" + str(date) + ".txt","r")
    goal = returnGoal()
    progressList = file.readlines()
    progress = 0
    for line in progressList:
        progress += int(line)
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
        file = open( "../data/" + str(date) + ".txt","r")
        goal = returnGoal()
        progressList = file.readlines()
        progress = 0
        for line in progressList:
            progress += int(line)
            print(progress)
        progress = float(progress) / float(goal)
        return progress


date = date.today()
addWater(0)
