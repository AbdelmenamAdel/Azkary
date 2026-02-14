import re

with open('lib/core/utils/azkar.dart', 'r') as f:
    content = f.read()

# Match ZekrModel with its arguments
# We want to catch the zekr: "..." or zekr: """..."""
pattern = r'ZekrModel\(\s*(?:title:.*?,|leading:.*?,|loop:.*?,)*\s*zekr:\s*("""(.*?)\"""|"(.*?)"|\'(.*?)\')(?:,.*?)*\)'
matches = re.finditer(pattern, content, re.DOTALL)

seen = {}
duplicates = []
for match in matches:
    zekr = match.group(2) or match.group(3) or match.group(4)
    if zekr:
        clean_zekr = zekr.strip()
        start_pos = match.start()
        # Find which list this belongs to by looking at the last 'final List<ZekrModel> name = [' before this pos
        list_matches = list(re.finditer(r'final List<ZekrModel> (\w+) = \[', content[:start_pos]))
        current_list = list_matches[-1].group(1) if list_matches else "unknown"
        
        id_str = f"{current_list}:{clean_zekr}"
        if id_str in seen:
            duplicates.append((seen[id_str], current_list, clean_zekr[:50] + "..."))
        seen[id_str] = current_list + ":" + str(start_pos)

if duplicates:
    for prev, current_list, snippet in duplicates:
        print(f"Duplicate found in {current_list}: {snippet}")
else:
    print("No duplicates found")
