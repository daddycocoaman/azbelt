import json

output = {}
with open("well_known_ids.txt") as f:
    for line in f.read().splitlines():
        name, ids = line.split("\t", maxsplit=1)
        for _id in ids.split():
            output[_id] = name
print(json.dumps(output, indent=4))
