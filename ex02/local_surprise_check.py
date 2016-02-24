#x = "dNQBPaJBVLJO^`WA^e_DM[V`TOQdKT_SRSaLX_FIA_\`\BD^LIe^WGWEee]FG]bO\ARedCaDBeS" 
x = "ERIOTTLDAEDJBHQMEOCLEFGKMFRHMGGCIEALTGJCGLQIICRQKL"

found = set()
violations = 0
for i in range(len(x)-1):
    a = x[i]
    b = x[i+1]
    pair = (a, b)
    if pair in found:
        violations += 1
    else:
        found.add(pair)
print 1 / (1 + violations)
