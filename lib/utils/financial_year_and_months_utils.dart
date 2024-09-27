

// Current year and month for calculating financial year
int currentYear = DateTime.now().year;
int currentMonth = DateTime.now().month;


// List of months (April to March)
List<String> months = [
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
  'January',
  'February',
  'March'
];

// Method to generate the last 8 financial years
List<String> getLast8FinancialYears() {
  List<String> financialYears = [];
  for (int i = 0; i < 8; i++) {
    int startYear = currentYear - (currentMonth < 4 ? i + 1 : i);
    int endYear = startYear + 1;
    financialYears.add('$startYear-${endYear.toString().substring(2)}');
  }
  return financialYears;
}

// Method to get months for the selected financial year
List<String> getMonthsForFinancialYear(String financialYear) {
  // Financial year months (April to March)
  List<String> financialYearMonths = [
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
    'January',
    'February',
    'March'
  ];

  // Get the current financial year (e.g., 2024-25)
  String currentFinancialYear = currentMonth < 4
      ? '${currentYear - 1}-${currentYear.toString().substring(2)}'
      : '$currentYear-${(currentYear + 1).toString().substring(2)}';

  // If the selected financial year is the current financial year,
  // return only months up to the current month
  if (financialYear == currentFinancialYear) {
    if (currentMonth >= 4) {
      return financialYearMonths.sublist(
          0, currentMonth - 3); // From April to current month
    } else {
      return financialYearMonths.sublist(
          0, currentMonth + 9); // From April last year to current month
    }
  }

  // For past financial years, return all months (April to March)
  return financialYearMonths;
}

// Method to get start date for the selected financial year and month
String getStartDateForMonth(String financialYear, String month) {
  Map<String, String> monthStartDates = {
    'April': '-04-01',
    'May': '-05-01',
    'June': '-06-01',
    'July': '-07-01',
    'August': '-08-01',
    'September': '-09-01',
    'October': '-10-01',
    'November': '-11-01',
    'December': '-12-01',
    'January': '-01-01',
    'February': '-02-01',
    'March': '-03-01',
  };

  List<String> years = financialYear.split('-');
  String startYear =
  (month == 'January' || month == 'February' || month == 'March')
      ? years[1]
      : years[0];

  return '$startYear${monthStartDates[month]}';
}

// Method to get end date for the selected financial year and month
String getEndDateForMonth(String financialYear, String month) {
  Map<String, String> monthEndDates = {
    'April': '-04-30',
    'May': '-05-31',
    'June': '-06-30',
    'July': '-07-31',
    'August': '-08-31',
    'September': '-09-30',
    'October': '-10-31',
    'November': '-11-30',
    'December': '-12-31',
    'January': '-01-31',
    'February': isLeapYear(int.parse(financialYear.split('-')[1]))
        ? '-02-29'
        : '-02-28',
    'March': '-03-31',
  };

  List<String> years = financialYear.split('-');
  String endYear =
  (month == 'January' || month == 'February' || month == 'March')
      ? years[1]
      : years[0];

  return '$endYear${monthEndDates[month]}';
}

// Method to check if a year is a leap year
bool isLeapYear(int year) {
  if (year % 4 == 0) {
    if (year % 100 == 0) {
      return year % 400 == 0;
    }
    return true;
  }
  return false;
}

// Method to get the current financial year
String getCurrentFinancialYear() {
  if (currentMonth < 4) {
    return '${currentYear - 1}-${currentYear.toString().substring(2)}';
  } else {
    return '$currentYear-${(currentYear + 1).toString().substring(2)}';
  }
}