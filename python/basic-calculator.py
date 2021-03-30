#Program to make a simple calculator

#addition
def add(x, y):
    return x + y

# function to subtract
def subtract(x, y):
    return x - y

# function to multiply
def multiply(x, y):
    return x * y

# function to divide 
def divide(x, y):
    return x / y
i = 0
while i != 1000:
    print("Select operation.")
    print("1.Add")
    print("2.Subtract")
    print("Multiply")
    print("4.Divide")

    # Take input from the user
    choice = input("Enter choice(1/2/3/4): ")

    num1 = float(input("Enter first number: "))
    num2 = float(input("Enter second number: "))

    if choice == '1':
        print(num1,"+",number2,"=", add(num1,num2))


    elif choice == '2':
        print(num1,"-",number2,"=", subtract(num1,num2))


    elif choice == '3':
        print(num1,"*",number2,"=", multiply(num1,num2))


    elif choice == '4':
        print(num1,"/",number2,"=", divide(num1,num2))

    elif chocice == '5':
        i = 1000
    else:
        print("Invalid input")

