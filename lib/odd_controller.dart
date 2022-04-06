String? getOdds(String value) {
  String? odd;
  switch (value) {
    case "H1":
      return "ODD";
    case "H2":
      return "ODD";
    case "H3":
      return "ODD";
    case 'H8':
      return odd = 'ODD';
    case 'H9':
      return odd = 'ODD';
    case 'H10':
      return 'ODD';
    case 'H11':
      return 'ODD';
    case 'H12':
      return 'EVEN';
    case 'H13':
      return 'EVEN';
    case 'H14':
      return 'EVEN';
    case "H15":
      return 'EVEN';
    case "H16":
      return 'EVEN';
    case "H17":
      return "EVEN";
    case "H18":
      return "EVEN";
    case 'H19':
      return 'EVEN';
    case 'H20':
      return 'EVEN';
    case "T11":
      return 'ODD';
    case "T18":
      return "ODD";
    case 'T7':
      return 'ODD';
    case 'T8':
      return "ODD";
    case "T20":
      return 'EVEN';
    default:
      odd = "EVEN";
  }
  return odd;
}
