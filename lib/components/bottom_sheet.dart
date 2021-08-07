import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ModalBottomSheet extends StatefulWidget {
  final Function addTx;
  ModalBottomSheet(this.addTx);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  DateTime _selectedDate = DateTime(1857);

  @override
  Widget build(BuildContext context) {
    void submitData(){
      if (amountController.text.isEmpty){
        return ;
      }
      final enteredTitle = titleController.text;
      final enteredAmount = double.parse(amountController.text);
      if (enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate.year == 1857){
        return ;
      }
      widget.addTx(enteredTitle,enteredAmount,_selectedDate);
      Navigator.pop(context);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Transaction Title",
            ),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => submitData(),
            decoration: InputDecoration(
              labelText: "Amount",
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                 child: Text(_selectedDate.year == 1857
                     ? "No Date Chosen"
                     : DateFormat.yMMMMd().format(_selectedDate)
                 ),
               ),
              TextButton(onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now()
                ).then((value){
                  if (value == null){
                    return ;
                  }
                  else{
                    setState(() {
                      _selectedDate = value;
                    });
                  }
                });
              }, child: Text("Choose Date"))
            ],
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
            onPressed: submitData,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Add Transaction",style: TextStyle(color: Colors.white),),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple),
            ),
          )
        ],
      ),
    );
  }
}
