from xlrd import open_workbook

class ReadCities:

    def __init__(self, path):
        self.distances_xlsx = open_workbook(path + "Distance.xlsx")
        self.costs_xlsx = open_workbook(path + "Cost.xlsx")
        self.distances = self.xlsx_to_list(self.distances_xlsx)
        self.costs = self.xlsx_to_list(self.costs_xlsx)

    def xlsx_to_list(self, xlsx):
        sheet = xlsx.sheets()[0]
        rows = []
        for row in range(1, sheet.nrows):
            values = []
            for col in range(1, sheet.ncols):
                value = sheet.cell(row,col).value;
                if (value == ""): values.append(-1)
                else: values.append(int(value))
            rows.append(values)
        return rows
