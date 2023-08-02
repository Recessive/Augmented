import sys

f = sys.argv[1]

ind1 = int(input("Enter first beatmap index to join: "))
ind2 = int(input("Enter second beatmap index to join: "))

lines = open(f).readlines()

l1 = lines[ind1 + 1].strip()
l2 = lines[ind2 + 1].strip()

print("".join([str(max(int(l1[i]), int(l2[i]))) for i in range(len(l1))]))
input()