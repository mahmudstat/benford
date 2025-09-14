# Welcome to Python Basics!

# Print a message to the console
print("Hello, World!")

# Variables and data types
name = "Mahmud" 
age = 25
is_learning = True

print(f"My name is {name}, I am {age} years old, and it is {is_learning} that I am learning Python.")

# Basic arithmetic
a = 10
b = 5
print("Addition:", a + b)
print("Subtraction:", a - b)
print("Multiplication:", a * b)
print("Division:", a / b)

# Lists
fruits = ["apple", "banana", "cherry"]
print("Fruits:", fruits)
fruits.append("orange")
print("Updated Fruits:", fruits)

# Loops
for fruit in fruits:
    print("I like", fruit)

# Functions
def greet(person):
    return f"Hello, {person}!"

print(greet("Mahmud"))

# If-else statements
if age > 18:
    print("You are an adult.")
else:
    print("You are a minor.")

# Dictionaries
person_info = {
    "name": "Mahmud",
    "age": 25,
    "city": "Dhaka"
}   

print("Person Info:", person_info)
print("Name:", person_info["name"])
# Adding a new key-value pair
person_info["job"] = "Engineer"
print("Updated Person Info:", person_info)      
