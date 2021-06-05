#!/bin/python3
import turtle
import random

colours =["purple", "pink", "white", "blue", "red"]
barry = turtle.Turtle()
turtle.Screen().bgcolor("black")

barry.penup()
barry.forward(90)
barry.left(45)
barry.pendown()
barry.color(random.choice(colours))
#barry.color("white")
def branch():
    for i in range(3):
        for i in range(3):
            barry.forward(30)
            barry.backward(30)
            barry.right(45)
        barry.left(90)
        barry.backward(30)
        barry.left(45)
    barry.right(90)
    barry.forward(90)

for i in range (8):
    branch() 
    barry.left(45)
    barry.color(random.choice(colours))

#for i in range(10):
#    for i in range(2):
#        barry.forward(100)
#        barry.right(60)
#        barry.forward(100)
#        barry.right(120)
        
#    barry.right(36)
    #barry.color(random.choice(colours))