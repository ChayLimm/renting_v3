import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/data/dummyData.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';


class RoomForm extends StatefulWidget {
  final Room? room;
  bool? isEditingTenant;

  RoomForm({super.key, this.room, this.isEditingTenant});

  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _isAdd;
  bool? isEditingTenant;

  late bool _noTenant;
  late String _roomName;
  late double _roomPrice;
  late String _identity;
  late String _contact;
  late int _rentsParking;
  late double _deposit;

  late double _waterMeter;
  late double _electricityMeter;

  @override
  void initState() {
    super.initState();

    // Initialize state based on whether we are adding or editing
    _isAdd = widget.room == null;
    _noTenant = widget.room?.tenant == null;
    if (!_noTenant && widget.isEditingTenant == null) {
      isEditingTenant = true;
    } else if (_noTenant && widget.isEditingTenant == true) {
      isEditingTenant = true;
    } else {
      isEditingTenant = false;
    }

    if (!_isAdd) {
      if (!_noTenant) {
        print("have tenant");
        _roomName = widget.room!.roomName;
        _roomPrice = widget.room!.roomPrice;
        _identity = widget.room!.tenant!.identity;
        _contact = widget.room!.tenant!.contact;
        _rentsParking = widget.room!.tenant!.rentsParking;
        _deposit = widget.room!.tenant!.deposit;
      } else {
        _roomName = widget.room!.roomName;
        _roomPrice = widget.room!.roomPrice;
        _identity = '';
        _contact = '';
        _rentsParking = 0;
        _deposit = 0.0;
      }
    } else {
      _roomName = '';
      _roomPrice = 0.0;
      _identity = '';
      _contact = '';
      _rentsParking = 0;
      _deposit = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<System>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isAdd ? 'Add Room' : 'Edit ${widget.room!.roomName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label(_isAdd ? 'Add Room' : 'Edit ${widget.room!.roomName}'),
                const SizedBox(height: 16),
                buildTextFormField(
                  label: "Room Name",
                  initialValue: _roomName,
                  onChanged: (value) => setState(() => _roomName = value),
                  validator: (value) => value == null || value.isEmpty
                      ? "Room Name is required."
                      : system.roomIsExist(value) &&
                              value != widget.room?.roomName
                          ? "Must be Unique"
                          : _isAdd ?  system.roomIsExist(value) ? " Room must be unique "
                          : null : null,
                ),
                const SizedBox(height: 16),
                buildTextFormField(
                  label: "Room Price",
                  initialValue: _roomPrice.toString() ,
                  onChanged: (value) =>
                      setState(() => _roomPrice = double.tryParse(value) ?? 0),
                  validator: (value) => value == null || value.isEmpty
                      ? "Room Price is required."
                      : null,
                  keyboardType: TextInputType.number,
                ),
                if (_isAdd) ...[
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Electricity",
                    onChanged: (value) => setState(
                        () => _electricityMeter = double.parse(value) ?? 0),
                    validator: (value) => value == null || value.isEmpty
                        ? "Room electricity is required."
                        : null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Water",
                    onChanged: (value) =>
                        setState(() => _waterMeter = double.parse(value) ?? 0),
                    validator: (value) => value == null || value.isEmpty
                        ? "Room water is required."
                        : null,
                    keyboardType: TextInputType.number,
                  )
                ],
                const SizedBox(height: 22),
                if (!isEditingTenant!) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingTenant = true;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                          boxShadow: [shadow()]),
                      child: const Center(
                        child: Text(
                          "Register tenant",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
                if (isEditingTenant!) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      label("Tenant"),
                      if (!_isAdd && !_noTenant)
                        Text(DateFormat('dd/MM/yyyy')
                            .format(widget.room!.tenant!.registerDate)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Tenant ID",
                    initialValue: _identity,
                    onChanged: (value) => setState(() => _identity = value),
                    validator: (value) => value == null || value.isEmpty
                        ? "Tenant ID is required."
                        : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Phone Number",
                    initialValue: _contact,
                    onChanged: (value) => setState(() => _contact = value),
                    validator: (value) => value == null || value.isEmpty
                        ? "Phone Number is required."
                        : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Vehicle",
                    initialValue: _rentsParking.toString(),
                    onChanged: (value) => setState(
                        () => _rentsParking = int.tryParse(value) ?? 0),
                    validator: (value) => value == null || value.isEmpty
                        ? "Parking is required."
                        : null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  buildTextFormField(
                    label: "Deposit",
                    initialValue: _deposit.toString(),
                    onChanged: (value) =>
                        setState(() => _deposit = double.tryParse(value) ?? 0),
                    validator: (value) => value == null || value.isEmpty
                        ? "Deposit is required."
                        : double.parse(value) > _roomPrice
                            ? "Deposit can not be higher than room price"
                            : null,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 32),
               Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Center(
          child: Text(
            "Cancel",
            style: TextStyle(color: blue),
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          Room newRoom = Room(
            id: _isAdd ? null : widget.room!.id,
            roomName: _roomName,
            roomPrice: _roomPrice,
            landlord: landlord,
          );

          if (!_isAdd) {
            system.updateRoom(newRoom);
            if (isEditingTenant!) {
              Tenant newTenant = Tenant(
                identity: _identity,
                contact: _contact,
                rentsParking: _rentsParking,
                deposit: _deposit,
              );
              system.manageTenant(newRoom, newTenant);
            }
          } else {
            if (isEditingTenant!) {
              Tenant newTenant = Tenant(
                identity: _identity,
                contact: _contact,
                rentsParking: _rentsParking,
                deposit: _deposit,
              );
              system.addRoom(newRoom, _waterMeter, _electricityMeter, newTenant);
            } else {
              system.addRoom(newRoom, _waterMeter, _electricityMeter);
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Update completed successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  ],
)

              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
