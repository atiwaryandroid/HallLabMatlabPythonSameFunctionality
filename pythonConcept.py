myMemory = [1, 3, 6, 8, 0, 5]
a = []
for i in range(1, 5):
    a.append(0)
for i in range(1, 5):
    a[i - 1] = myMemory[i - 1]
print("Original myMemory\n")
for i in range(1, 7):
    print("myMemory[" + str(i - 1) + "] = " + str(myMemory[i - 1]))
print("First\n")
for i in range(1, 5):
    print("a[" + str(i - 1) + "] = " + str(a[i - 1]))
print("Modifying myMemory.......\n")
for i in range(1, 3):
    myMemory[i - 1] = 0
print("Modified myMemory\n")
for i in range(1, 7):
    print("myMemory[" + str(i - 1) + "] = " + str(myMemory[i - 1]))
print("Second\n")
for i in range(1, 5):
    print("a[" + str(i - 1) + "] = " + str(a[i - 1]))