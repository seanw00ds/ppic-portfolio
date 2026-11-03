import sys
from collections import Counter

text = open(sys.argv[1], encoding="utf-8").read().lower()
counts = Counter(c for c in text if c in "aeiou")
for vowel in "aeiou":
    print(f"{vowel}: {counts[vowel]}")
print(f"total: {sum(counts.values())}")
