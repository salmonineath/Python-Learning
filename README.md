# 🐍 1-Week Python Mastery Plan

> **Background:** Coming from JavaScript (React, Next.js, Express) and Java (Spring Boot)
> **Goal:** Learn Python syntax + understand how Python works under the hood
> **Environment:** Docker (no local Python needed)

---

## 📁 Project Structure

```
python-week/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── days/
    ├── day1/
    │   └── main.py
    ├── day2/
    │   └── main.py
    ├── day3/
    │   └── main.py
    ├── day4/
    │   └── main.py
    ├── day5/
    │   └── main.py
    ├── day6/
    │   └── main.py
    └── day7/
        └── main.py
```

---

## 🐳 Docker Setup

**`Dockerfile`**
```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "days/day1/main.py"]
```

**`docker-compose.yml`**
```yaml
services:
  app:
    build: .
    volumes:
      - .:/app
    command: python days/day1/main.py
```

> The `volumes` line mounts your local folder into the container.
> This means you edit files locally and the container sees changes instantly.
> **No rebuild needed when you edit code.**

**`requirements.txt`**
```
# empty for now — add packages here as needed
# then run: docker compose up --build
```

---

## 🔧 Daily Workflow

```bash
# First time only — build the image
docker compose up --build

# Get a shell inside the container (most convenient)
docker compose run app bash

# Once inside the container shell:
python days/day1/main.py    # run day 1
python days/day2/main.py    # run day 2
python                       # open Python REPL to experiment
exit                         # leave the container

# Or run directly without entering the shell
docker compose run app python days/day1/main.py
```

> Only run `docker compose up --build` again when you add a new package to `requirements.txt`
> (same as rebuilding after changing `package.json` in Node)

---

## 📅 Week at a Glance

| Day | Syntax Focus | Internal Concept | Mini Project |
|-----|-------------|-----------------|--------------|
| 1 | Types, functions, f-strings | Everything is an object | Tip calculator |
| 2 | Lists, dicts, comprehensions | Iteration protocol | Word frequency counter |
| 3 | Classes, magic methods | Object model, dunders | Inventory system |
| 4 | Errors, files, modules | Import system | Bank account |
| 5 | Decorators, lambdas | Functions as objects | Timer & retry decorators |
| 6 | References, mutability | Memory, GC, GIL | Mutation demo |
| 7 | Generators, async/await | Lazy eval, event loop | Async task runner |

---

## Day 1 — Syntax & Types

### Key Concepts
- No semicolons, no curly braces — **indentation is the syntax**
- Dynamic typing (like JS) but strongly typed (like Java — no silent coercions)
- Core types: `str`, `int`, `float`, `bool`, `None`
- f-strings (like JS template literals)
- Functions with `def`, default args, keyword args

### Things That Will Surprise You

```python
# No 'let', 'const', 'var' — just assign
name = "Alice"

# Everything is an object — even integers
print((42).bit_length())   # → 6

# None is not null — it's a real object
x = None
print(type(x))   # → <class 'NoneType'>

# No implicit type coercion (unlike JS)
# JS would turn this into "55" silently — Python refuses
"5" + 5   # ❌ TypeError — you must be explicit
str(5) + "5"   # ✅ → "55"
int("5") + 5   # ✅ → 10

# f-strings — like JS template literals
age = 25
print(f"I am {age} years old")   # JS: `I am ${age} years old`

# Keyword arguments
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")                    # → Hello, Alice!
greet("Alice", greeting="Hey")    # → Hey, Alice!
```

### Python's Philosophy
Python follows **"explicit is better than implicit"**. It will never silently guess what you meant.
If you mix types, Python stops and tells you immediately — a loud error now is better than a silent wrong result in production.

### Mini Project — CLI Tip Calculator
- Input: bill amount, tip percentage, number of people
- Output: tip amount per person, total per person
- Use: `input()`, `float()`, `int()`, f-strings

---

## Day 2 — Collections & Comprehensions

### Key Concepts
- `list` → like JS array
- `dict` → like JS object
- `tuple` → immutable list (can't change after creation)
- `set` → unique values only
- List/dict comprehensions — Python's superpower

### Things That Will Surprise You

```python
# List comprehension — replaces .map() and .filter()
numbers = [1, 2, 3, 4, 5]
doubled = [n * 2 for n in numbers]            # JS: numbers.map(n => n * 2)
evens   = [n for n in numbers if n % 2 == 0]  # JS: numbers.filter(n => n % 2 === 0)

# Dict comprehension
squared = {n: n**2 for n in numbers}   # → {1:1, 2:4, 3:9, 4:16, 5:25}

# Tuples — immutable, used for fixed data
point = (10, 20)
x, y = point   # unpacking — like JS destructuring

# Sets — unique values only, duplicates removed automatically
tags = {"python", "docker", "python"}
print(tags)   # → {"python", "docker"}

# Unpacking in loops
users = [("Alice", 25), ("Bob", 30)]
for name, age in users:
    print(f"{name} is {age}")
```

### Mini Project — Word Frequency Counter
- Input: a hardcoded paragraph string
- Output: top 5 most used words as a dict
- Use: `.split()`, `.lower()`, dict comprehension, `sorted()`

---

## Day 3 — OOP & How Classes Really Work

### Key Concepts
- Classes similar to Java but more flexible
- `__init__` → constructor, `self` → like `this`
- Dunder/magic methods (e.g. `__repr__`, `__eq__`, `__lt__`)
- Dataclasses — modern, less boilerplate (like Java records / Lombok @Data)

### Things That Will Surprise You

```python
# __repr__ — like Java's toString()
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __repr__(self):
        return f"User(name={self.name}, age={self.age})"

    def __eq__(self, other):      # like Java's .equals()
        return self.name == other.name

    def __lt__(self, other):      # enables sorting!
        return self.age < other.age

users = [User("Bob", 30), User("Alice", 25)]
print(sorted(users))   # works because we defined __lt__

# Dataclass — much less boilerplate
from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    in_stock: bool = True   # default value
```

### Mini Project — Inventory System
- Add products (name, price, in_stock)
- List all products sorted by price
- Find a product by name
- Use: `@dataclass`, list of objects, `sorted()`, comprehensions

---

## Day 4 — Errors, Files & Modules

### Key Concepts
- `try/except/finally` → like JS/Java try/catch
- Custom exceptions — extend the `Exception` class
- Reading/writing files with context managers (`with` keyword)
- How Python modules and imports work

### Things That Will Surprise You

```python
# Custom exceptions
class InsufficientFundsError(Exception):
    def __init__(self, amount, balance):
        super().__init__(f"Can't withdraw {amount}, balance is {balance}")

# try/except
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
finally:
    print("This always runs")

# Context managers — auto-close files (like try-with-resources in Java)
with open("data.txt", "w") as f:
    f.write("hello")
# file is automatically closed here — no f.close() needed

# Reading a file
with open("data.txt", "r") as f:
    content = f.read()

# Modules — any .py file is a module
# If you have: utils/math.py with a function add()
# Import it like: from utils.math import add
```

### Mini Project — Bank Account
- Deposit and withdraw money
- Raise `InsufficientFundsError` on overdraft
- Save all transactions to a `.txt` file
- Load transaction history on startup
- Use: classes, custom exceptions, file I/O

---

## Day 5 — Functional Python & Decorators

### Key Concepts
- Functions as first-class citizens (like JS)
- `lambda` → like JS arrow functions
- `map()`, `filter()`
- Decorators — Python's killer feature (like middleware in Express)
- `*args` and `**kwargs`

### Things That Will Surprise You

```python
# Lambda — like JS arrow functions
double = lambda x: x * 2        # JS: const double = x => x * 2

# *args — variable number of positional arguments
def add(*numbers):
    return sum(numbers)

add(1, 2, 3, 4)   # → 10

# **kwargs — variable number of keyword arguments
def display(**info):
    for key, value in info.items():
        print(f"{key}: {value}")

display(name="Alice", age=25)

# Decorators — wraps a function with extra behavior
# This is exactly like Express middleware
def logger(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Done")
        return result
    return wrapper

@logger              # same as: greet = logger(greet)
def greet(name):
    print(f"Hello {name}")

greet("Alice")
# Calling greet
# Hello Alice
# Done
```

> FastAPI and Django use decorators everywhere: `@app.get("/")`, `@login_required`
> This is the same pattern as Express middleware — wrapping functions with extra behavior.

### Mini Project — Decorator System
- `@timer` — measures and prints how long a function takes to run
- `@retry(n)` — retries a function N times if it raises an exception
- Use: decorators, `time` module, `*args/**kwargs`

---

## Day 6 — Under The Hood: Memory & The Object Model

### Key Concepts
- Everything in Python is an object with an identity (memory address)
- Variables are **labels/references** — not boxes holding values
- Mutable vs Immutable types
- Reference counting and garbage collection
- The GIL (Global Interpreter Lock)

### Things That Will Surprise You

```python
# Everything is an object with a memory address
x = 42
print(id(x))      # memory address of the object
print(type(x))    # <class 'int'>

# Variables are labels pointing to objects — not boxes
a = [1, 2, 3]
b = a              # b and a point to the SAME list in memory
b.append(4)
print(a)           # → [1, 2, 3, 4]  ← a changed too!

# To actually copy: use .copy()
b = a.copy()
b.append(5)
print(a)           # → [1, 2, 3, 4]  ← a unchanged now

# Python interns (reuses) small integers -5 to 256
x = 256; y = 256
print(x is y)   # → True  (exact same object in memory)
x = 257; y = 257
print(x is y)   # → False (two different objects)

# is vs == 
# is  → checks identity (same object in memory?)
# ==  → checks equality (same value?)
a = [1, 2, 3]
b = [1, 2, 3]
print(a == b)   # → True  (same values)
print(a is b)   # → False (different objects)

# Mutable types  (can change in memory): list, dict, set
# Immutable types (cannot change):       int, str, tuple, float
```

### Concepts to Research
- **Reference counting** — how Python tracks when to free memory
- **Garbage collector** — handles circular references that reference counting misses
- **GIL (Global Interpreter Lock)** — why Python threads don't truly run in parallel
- **CPython** — the standard Python interpreter written in C

### Mini Project — Mutation Demo
- Demonstrate the difference between reference and copy
- Show a mutation bug (accidentally changing data you didn't mean to)
- Show how to fix it with `.copy()` and `copy.deepcopy()`

---

## Day 7 — Generators, Async & Putting It Together

### Key Concepts
- Generators — lazy evaluation, memory efficient
- `yield` — pauses a function and resumes later
- `async/await` — identical concept to JS/Express, you already know this!
- `asyncio.gather()` — like `Promise.all()` in JS

### Things That Will Surprise You

```python
# Generators — like JS generators
def count_up(n):
    for i in range(n):
        yield i   # pauses here, resumes on next call

gen = count_up(1_000_000)   # uses almost NO memory — nothing is computed yet
print(next(gen))   # → 0   (compute just this one)
print(next(gen))   # → 1   (compute just this one)

# async/await — identical to JS
import asyncio

async def fetch_data(id):
    await asyncio.sleep(1)    # like: await someApiCall()
    return {"id": id, "data": "..."}

async def main():
    # Run concurrently — like Promise.all()
    results = await asyncio.gather(
        fetch_data(1),
        fetch_data(2),
        fetch_data(3),
    )
    print(results)

asyncio.run(main())   # entry point — like app.listen() in Express
```

### Mini Project — Async Task Runner
- Accept a list of jobs (each job is just a name + random sleep duration)
- Run all jobs concurrently with `asyncio.gather()`
- Track status of each job: pending → running → done
- Save results to a `results.json` file when all jobs complete
- Use: `async/await`, `asyncio`, `json` module, `dataclasses`

---

## 🧠 Key Python vs JS/Java Reminders

| Concept | JavaScript | Java | Python |
|---------|-----------|------|--------|
| Variable declaration | `let x = 5` | `int x = 5` | `x = 5` |
| Null value | `null` / `undefined` | `null` | `None` |
| String interpolation | `` `Hello ${name}` `` | — | `f"Hello {name}"` |
| Array / List | `[]` | `ArrayList` | `[]` |
| Object / Dict | `{}` | `HashMap` | `{}` |
| Arrow / Lambda | `x => x * 2` | — | `lambda x: x * 2` |
| Try/catch | `try/catch` | `try/catch` | `try/except` |
| Async | `async/await` | — | `async/await` |
| Type coercion | Silent (dangerous) | Strict | Strict + loud errors |
| Decorator / Middleware | Express middleware | Annotations `@` | `@decorator` |
| toString | `.toString()` | `.toString()` | `__repr__` |
| Equals | `===` | `.equals()` | `==` |

---

## 💡 Tips

- If you see a `TypeError` — you're mixing types. Be explicit with conversions.
- If you see an `IndentationError` — your spacing is inconsistent. Use 4 spaces.
- If you see an `ImportError` — the module isn't installed. Add it to `requirements.txt` and rebuild.
- Use `print(type(x))` whenever you're unsure what type something is.
- Use `help(something)` in the Python REPL for instant docs.
- Use `dir(something)` to see all methods available on an object.