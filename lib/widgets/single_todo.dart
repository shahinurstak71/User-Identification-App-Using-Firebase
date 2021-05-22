import 'package:flutter/material.dart';

class SingleTodo extends StatelessWidget {
  final String title;
  final String description;
  final String id;
  final Function delFunction;
  final Function editFunction;
  SingleTodo({
    this.title,
    this.description,
    this.id,
    this.delFunction,
    this.editFunction,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    editFunction(id);
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.green,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    delFunction(id);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
