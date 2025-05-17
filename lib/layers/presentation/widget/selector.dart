import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:flutter/material.dart';

Widget buildSelector({
  required String title,
  required String selectBotId,
  required Function(String) onChanged,
}) {
  // Danh sách bots được tạo từ Enums và Name
  final List<Bot> bots = Botlist.bots;

  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: title,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
    ),
    value: selectBotId,
    items:
        bots.map((bot) {
          return DropdownMenuItem<String>(
            value: bot.id,
            child: Text(
              bot.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          );
        }).toList(),
    onChanged: (String? newValue) {
      if (newValue != null) {
        onChanged(newValue);
      }
    },
  );
}
