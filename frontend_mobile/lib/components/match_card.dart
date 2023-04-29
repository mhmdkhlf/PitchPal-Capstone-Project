import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final String matchDate;
  final String matchTime;

  const MatchCard({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.matchDate,
    required this.matchTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                homeTeamName,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'vs',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              Text(
                awayTeamName,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(matchDate),
              const SizedBox(width: 16),
              const Icon(Icons.access_time),
              const SizedBox(width: 8),
              Text(matchTime),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Field name & location'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Details'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
