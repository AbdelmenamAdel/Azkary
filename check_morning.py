import re

with open('lib/core/utils/azkar.dart', 'r') as f:
    content = f.read()

# Extract the morning list block
morning_match = re.search(r'final List<ZekrModel> morning = \[(.*?)\];', content, re.DOTALL)
if morning_match:
    morning_content = morning_match.group(1)
    # Find all zekr blocks
    zekr_matches = re.findall(r'zekr:\s*("""(.*?)\"""|"(.*?)"|\'(.*?)\')', morning_content, re.DOTALL)
    
    seen = {}
    for i, match in enumerate(zekr_matches):
        zekr_text = (match[1] or match[2] or match[3]).strip()
        if zekr_text in seen:
            print(f"Duplicate in morning at index {i} (first at {seen[zekr_text]})")
            print(f"Content: {zekr_text[:100]}...")
        seen[zekr_text] = i
