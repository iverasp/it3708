#x = "dNQBPaJBVLJO^`WA^e_DM[V`TOQdKT_SRSaLX_FIA_\`\BD^LIe^WGWEee]FG]bO\ARedCaDBeS"
x = "MRMTOMNDCETMIKZFQTDJGKHSXZSAUBRYSBUXEMOZREVJFYXYDYJUH"

found = set()
violations = 0
for i in range(len(x)):
    for j in range(i + 1, len(x)):
        a = x[i]
        b = x[j]
        seq = (a, b, j - i)
        if seq in found:
            violations += 1
        else:
            found.add(seq)
print violations
print 1 / (1 + violations)    
