// Define a class to represent the data structure
class ExcelData {
  final String? gstinOfSupplier;
  final String? tradeLegalName;
  final String? invoiceNumber;
  final String? invoiceDate;
  final String? invoiceValue;
  final String? rate;
  final String? taxableValue;
  final String? integratedTax;
  final String? centralTax;
  final String? stateUtTax;

  ExcelData(
      {
        required this.gstinOfSupplier,
        required this.tradeLegalName,
        required this.invoiceNumber,
        required this.invoiceDate,
        required this.invoiceValue,
        required this.rate,
        required this.taxableValue,
        required this.integratedTax,
        required this.centralTax,
        required this.stateUtTax});
}