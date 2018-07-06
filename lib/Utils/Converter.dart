class Converter {
  static List<String> months = const ["Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.",
  "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."];

  static List<String> monthsFull = const ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];

  static String dateToString(DateTime date) {
    String year;
    String month;
    String day;
    String time;

    year = date.year.toString();
    month = months[date.month - 1];
    day = date.day.toString();
    // if time is 12 am
    if (date.hour == 0) {
      time = "12";
    } else if (date.hour > 12) {
      time = (date.hour - 12).toString();
    } else {
      time = date.hour.toString();
    }
    time += date.minute < 10 ? ":0${date.minute}" : ":${date.minute} ";
    time += date.hour > 12 ? "PM" : "AM";

    return "$month $day, $year at $time";
  }

  static String dateToHeader(DateTime date) {
    String year;
    String month;
    String day;

    year = date.year.toString();
    month = monthsFull[date.month - 1];
    day = date.day.toString();

    return "$month $day, $year";
  }
}