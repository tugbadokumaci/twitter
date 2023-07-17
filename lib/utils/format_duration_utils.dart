String formatDuration(Duration duration) {
  if (duration.inDays >= 365) {
    int years = (duration.inDays / 365).floor();
    return '$years${years > 1 ? 'y' : 'y'}';
  } else if (duration.inDays >= 30) {
    int months = (duration.inDays / 30).floor();
    return '$months${months > 1 ? 'm' : 'm'}';
  } else if (duration.inDays >= 1) {
    return '${duration.inDays}${duration.inDays > 1 ? 'd' : 'd'}';
  } else if (duration.inHours >= 1) {
    return '${duration.inHours}${duration.inHours > 1 ? 'h' : 'h'}';
  } else if (duration.inMinutes >= 1) {
    return '${duration.inMinutes}${duration.inMinutes > 1 ? 'm' : 'm'}';
  } else {
    return '${duration.inSeconds}${duration.inSeconds > 1 ? 's' : 's'}';
  }
}
