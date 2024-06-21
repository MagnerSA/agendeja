Map<int, String> monthNames = {
  1: "Janeiro",
  2: "Fevereiro",
  3: "Março",
  4: "Abril",
  5: "Maio",
  6: "Junho",
  7: "Julho",
  8: "Agosto",
  9: "Setembro",
  10: "Outubro",
  11: "Novembro",
  12: "Dezembro",
};

String formatDate(DateTime date, bool hideName) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = today.add(Duration(days: 1));
  DateTime dayAfterTomorrow = today.add(Duration(days: 2));
  DateTime yesterday = today.subtract(Duration(days: 1));

  DateTime targetDate = DateTime(date.year, date.month, date.day);

  String formatted = '${date.day} de ${monthNames[date.month]}';

  if (!hideName) {
    if (targetDate.isAtSameMomentAs(today)) {
      formatted = 'Hoje (${date.day} de ${monthNames[date.month]})';
    } else if (targetDate.isAtSameMomentAs(tomorrow)) {
      formatted = 'Amanhã (${date.day} de ${monthNames[date.month]})';
    } else if (targetDate.isAtSameMomentAs(dayAfterTomorrow)) {
      formatted = 'Depois de Amanhã (${date.day} de ${monthNames[date.month]})';
    } else if (targetDate.isAtSameMomentAs(yesterday)) {
      formatted = 'Ontem (${date.day} de ${monthNames[date.month]})';
    } else {
      formatted = '${date.day} de ${monthNames[date.month]}';
    }
  }

  return formatted;
}
