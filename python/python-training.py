# name = value
#vaiables and types
x_postition = 10.0

print(x_postition)

x_postition = 15


#lists

name = [5, True, "string"]
empty = []

enemy_positions = [5, 10, 15]
enemy_positions = [5, 10, 15, 20]

print(len(enemy_positions))

print(enemy_positions[0])

enemy_positions[0] = 6
print(enemy_positions)

print(enemy_positions[0:2])

enemy_positions.append(25)
print(enemy_positions)

enemy_positions.insert(1,9)
print(enemy_positions)

enemy_positions.remove(6)
print(enemy_positions)

del(enemy_positions[2])
print(enemy_positions)
print(x_postition)

pi = 3.14
print(pi)

print(str(pi + x_postition))
x = type(x_postition)
print(x)

# booleans and strings
is_game_over = False
is_game_over = True

print(is_game_over)
print(type(is_game_over))

is_game_over = 1
print(is_game_over)
print(type(is_game_over))

name = 'Harry-Thaine'
print(name)

if is_game_over == False:
  print('Game On')
else:
  print('Game Over')

age = 24
print(name + ' is ' + str(age))

name_and_age = "Harry: {} soon to be {}".format(age, age + 1)
print(name_and_age)


# + - * / % // ** =

x_position = 10
print(x_position)
forward = x_position + 1
print(forward)
backward = x_position  - 1
print(backward)

remainder = 5 % 2
print(remainder)

floor_division = 5 // 2
print(floor_division)

five_squared = 5 ** 2
print(five_squared)

# x_position = x_position + 1  is the same as  x_position += 1
print(x_position)


First_name = "Harry-Thaine "
Last_name = "Brass"
print(First_name + Last_name)

# > >= >= == != not or and

x_position = 10
end_position = 10

is_at_end = x_position == end_position
print(is_at_end)

is_at_halfway = x_position >= end_position / 2
print(is_at_halfway)

not_is_at_end = not is_at_end

print(not_is_at_end)

#score = 10
#is_game_over = score >= 10 and is_at_end
#print(is_game_over)

score = 9
is_game_over = score >= 10 or is_at_end
print(is_game_over); print("two statements on one line")

#lists

name = [5, True, "string"]
empty = []

enemy_positions = [5, 10, 15]
enemy_positions = [5, 10, 15, 20]

print(len(enemy_positions))

print(enemy_positions[0])

enemy_positions[0] = 6
print(enemy_positions)

print(enemy_positions[0:2])

enemy_positions.append(25)
print(enemy_positions)

enemy_positions.insert(1,9)
print(enemy_positions)

enemy_positions.remove(6)
print(enemy_positions)

del(enemy_positions[2])
print(enemy_positions)

# tuples
#[] aka list can be transformed, () aka tuple can not
high_score = ("Harry-Thaine", 121)
print(high_score)

high_score = ("Sooty", 1000000)
print(high_score)

name = high_score[0]
print(name)

print(len(high_score))

print("Harry-Thaine" in high_score)

#valid when high_score = [] but not when high_score = ()
#high_score[1] = high_score[1] + 1 
#print(high_score)

# string in list/ tuples
print(name[0])
print(name[0:2])
print("Soot" in name)
print(len(name))

# dictionarys

actions = {"r":1, "l":-1}
print(actions)


print(actions["r"])
print(actions.get("g"))

actions["r"] = 2
actions["u"] = 1
print(actions)

print(actions.keys())
print(actions.values())
print(actions.items())

del(actions["u"])
print(actions)

actions.pop("r")
print(actions)

print("l" in actions)

# if statements

condition = True
if condition == True:
  print("True :D")
else:
  print("False D:")

print("Please Enter 'l' or 'r'")
key = input()
#key = "l" # l or r or other
if key == "r":
  print("Move right")
  print("press l or r again")
  key2 = input()
  if key2 == "r":
    print("r again I see!")
  elif key2 == "l":
      print("back to where you started, wild!")
  else:
    print("that's not right!, use l or r next time!")
elif key == "l":
  print("Move left")
  print("press l or r again")
  key2 = input()
  if key2 == "r":
    print("back to where you started, wild!")
  elif key2 == "l":
      print("l again, what a wild thing!")
else:
  print("Invalid key")

print("done")

# while loops

position = 0
end_position = 10
enemy_position = 9

while position < end_position:
  position += 1
  print(position)
  if position == enemy_position:
    print("Game over!")
    break
if position == end_position:  
  print("You have reached the end")

# continue lets you skip to the next loop iteration 

#for loop
enemy_positions = [5, 10, 15]

for enemy_position in enemy_positions:
  print(enemy_position)

for i in range(0,5):
  print("Hello")

# Functions
position = 0

def move_player():
  global position
  position += 1
  print(position)

  x_position = position
  print(x_position) # functions created in functions only live inside of the functions
 
move_player()
move_player()
move_player()

#functions
position = 0

def move_player(position, by_amount):
  position += by_amount
  #print(position)
  return position
 
position = move_player(position, 5)
position = move_player(position, 2)
print(position)

# objects and classes
class GameObject:
  
  def __init__(self, name, x_pos, y_pos):
    self.name = name
    self.x_pos = x_pos
    self.y_pos = y_pos

game_object = GameObject("Enemy", 1, 2)
print(game_object.name)
game_object.name = "Enemy 1"
print(game_object.name)

# objects and classes part 1
class GameObject:
  
  def __init__(self, name, x_pos, y_pos):
    self.name = name
    self.x_pos = x_pos
    self.y_pos = y_pos

  def move(self, by_x_amount, by_y_ammount):
    self.x_pos += by_x_amount
    self.y_pos += by_y_ammount

game_object = GameObject("Enemy", 1, 2)
print(game_object.name)
game_object.name = "Enemy 1"
print(game_object.name)

print(game_object.x_pos)
print(game_object.y_pos)

game_object.move(5,10)
print(game_object.x_pos)
print(game_object.y_pos)

other_game_object = GameObject("Player", 2, 0)
print(other_game_object.name)
print(other_game_object.x_pos)
print(other_game_object.y_pos)

one_int = 5
another_int = one_int
print(one_int)
print(another_int)

another_int = 10
print(one_int)
print(another_int)

other_game_object = game_object
print(other_game_object.name)

other_game_object.name = "new name"
print(other_game_object.name)
print(game_object.name)


# objects and classes part 2
class GameObject:
  
  def __init__(self, name, x_pos, y_pos):
    self.name = name
    self.x_pos = x_pos
    self.y_pos = y_pos

  def move(self, by_x_amount, by_y_ammount):
    self.x_pos += by_x_amount
    self.y_pos += by_y_ammount



class Enemy(GameObject):

  def __init__(self, name, x_pos, y_pos, health):
    super().__init__(name,x_pos, y_pos)
    self.health = health

  def take_damage(self, amount):
    self.health -= amount


game_object = GameObject("Game object", 1, 2)
enemy = Enemy("Enemy", 5, 10, 100)

print(game_object.name)
print(enemy.name)

enemy.take_damage(20)
print(enemy.health)
