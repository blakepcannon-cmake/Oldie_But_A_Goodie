#Author: Blake Cannon
#Date: 09/25/2015
#Title: Variable Change 1.0

#import libraries
import random

#Randomize door selection function
def DoorSelect():
	#Door Storage  setup and Reset
	door_dict = dict()
	door_dict["A"]="Goat"
	door_dict["B"]="Goat"
	door_dict["C"]="Goat"
	#Randomize selection
	carDoor=random.choice("ABC")
	print("The car is behind door %s" % carDoor) #Where is the car?
	door_dict[carDoor]="Car" #Assign car to above randomized selection
	return door_dict,carDoor
#END of DoorSelect function
	
def UserSelect():
	userPick=random.choice("ABC") #pick random door
	print("The player selected door %s" % userPick)
	return userPick
#END of UserSelect
	
def winEvalFirst(iterations):
	#Declare Counters
	winCount=0
	lossCount=0
	#Loop over number of iterations
	for i in range(iterations):
		print("This iteration number: %i" % (i+1)) #Print iteration number
		doorConfig=DoorSelect() #pull together door condiguration from DoorSelect function
		#print(doorConfig) #What is the setup?
		print("A %s is behind door A" % doorConfig[0]["A"])
		print("A %s is behind door B" % doorConfig[0]["B"])
		print("A %s is behind door C" % doorConfig[0]["C"])
		userPick=UserSelect()
		#Evaluate winner and print
		if doorConfig[1] == userPick:
			winCount+=1 #up the winCount for reporting on multiple iterations
			print("User Wins")
		else:
			lossCount+=1 #up the lossCount for reporting on multiple iterations
			print("User Loses")
		i+=1
	print("On the first guess, the user won %i times and lost %i times" % (winCount,lossCount))
#End of winEvalFirst function
	
def Reveal(userSelection,doorConfig):
	options = ["A","B","C"] #List of options
	options.remove(userSelection) #remove user selection from revelation options
	if doorConfig[0][options[1]] == "Car": #Remove door with Car from revelation options
		options.remove(options[1]) #remove if it's a car
	else:
		options.remove(options[0]) #remove other if it's not a car (only two options left at this point)
	revelation = str(options[0])
	print("The door that is revealed is %s" % revelation)
	return revelation #Door that is revealed
#END of Reveal function
	
def winEvalSecond(iterations):
	#Declare Counters
	winCount=0
	lossCount=0
	for i in range(iterations):
		print("This iteration number: %i" % (i+1)) #Print iteration number
		doorConfig=DoorSelect() #pull together door condiguration from DoorSelect function
		print("A %s is behind door A" % doorConfig[0]["A"])
		print("A %s is behind door B" % doorConfig[0]["B"])
		print("A %s is behind door C" % doorConfig[0]["C"])
		userPick1=UserSelect() #initial pick by player
		revealDoor=Reveal(userPick1,doorConfig) #which door is revealed
		doors=["A","B","C"]
		doors.remove(userPick1) #User won't select first pick`
		doors.remove(revealDoor) #User won't select the revealed door (it's a goat)
		userPick2=doors[0] #pick final door
		print("The player switched his answer to door: %s" % userPick2)
		#Evaluate winner and print
		if doorConfig[1] == userPick2:  #doorConfig[1] is the door selection
			winCount+=1
			print("User Wins")
		else:
			lossCount+=1
			print("User Loses")
		i+=1
	print("When switching after another door was revealed, the user won %i times and lost %i times" % (winCount,lossCount))
	
#Init Program
def Main():
	#Data Validation
	while True:
		try:
			howMany=int(input("Please enter the number of iterations you'd like to complete: "))
		except ValueError:
				print("That is not a valid answer, please enter an integer.")
				continue
		else:
			#successful parse
			break	
	while True:
		try: 
			switch=str(input("If given the option, is it in your interest to change your answer? (y/n)"))
		except ValueError:
			print("That is not a valid answer, please enter a lower case 'y' or 'n'")
			continue
		if (switch!="n"):
			if (switch!="y"):
				print("That is not a valid answer, please enter a lower case 'y' or 'n'")
				continue
			else:
				break #successful
		else:
			#successful parse
			break
	if switch=="n":
		winEvalFirst(howMany)
	elif switch=="y":
		winEvalSecond(howMany)
	else:
		pass
#Run Program
Main()