import 'package:flutter/material.dart';
import 'maze_builder_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              '🤖 AI Maze Runner',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),

            Text(
              'Watch AI algorithms race to solve mazes!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            // Algorithm showcase
            Text(
              'Algorithms Available:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),

            // Algorithm cards
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.ALGORITHM_COLORS.entries.map((entry) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: entry.value.withOpacity(0.1),
                    border: Border.all(color: entry.value),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      color: entry.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 60),

            // Start button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MazeBuilderScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Start Building Mazes!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Features
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildFeature('🎨', 'Draw custom mazes'),
                  _buildFeature('🏁', 'Race algorithms side-by-side'),
                  _buildFeature('📊', 'Compare performance metrics'),
                  _buildFeature('🎯', 'Visual pathfinding animation'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}