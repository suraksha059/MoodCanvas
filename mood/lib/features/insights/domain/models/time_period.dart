/// Time window options for filtering emotional insights.
enum TimePeriod {
  thisWeek('This week'),
  thisMonth('This month'),
  allTime('All time');

  final String label;
  const TimePeriod(this.label);
}
