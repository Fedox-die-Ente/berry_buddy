import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../repositories/userRepository.dart';
import '../../utils/icons.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  String? gender, interestedIn;
  DateTime? age;
  Position? position;
  ProfileBloc? _profileBloc;
  Uint8List? fileBytes;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      fileBytes != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc?.add(
      Submitted(
        name: _nameController.text,
        age: age!,
        position: position!,
        gender: gender!,
        photo: fileBytes!,
      ),
    );
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed");
        }
        if (state.isSubmitting) {
          print("Submitting");
        }
        if (state.isSuccess) {
          print("Success!");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.deepPurple.shade900,
                      Colors.deepPurple.shade800,
                      Colors.deepPurple.shade400,
                    ],
                  ),
                ),
                width: size.width,
                height: size.height,
              ),
              Positioned(
                top: size.height * 0.1,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: size.width * 0.15,
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null) {
                                setState(() {
                                  fileBytes = result.files.first.bytes;
                                });
                              }
                            },
                            child: fileBytes == null
                                ? Image.asset('profilephoto.png')
                                : CircleAvatar(
                                    radius: size.width * 0.15,
                                    backgroundImage: MemoryImage(fileBytes!),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ProfileImagePanel(),
                        const SizedBox(height: 20),
                        textFieldWidget(
                          _nameController,
                          "Name",
                          size,
                          Icons.person,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            DateTime currentDate = DateTime.now();
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: currentDate,
                              firstDate: DateTime(1900),
                              lastDate: currentDate,
                            );

                            if (pickedDate != null &&
                                pickedDate != currentDate) {
                              _birthdateController.text =
                                  pickedDate.toLocal().toString().split(' ')[0];
                              age = pickedDate;
                            }
                          },
                          child: AbsorbPointer(
                            child: textFieldWidget(
                              _birthdateController,
                              "Birthdate",
                              size,
                              Icons.calendar_today,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            genderListWidget(
                              ["Male", "Female", "Transgender", "Non-Binary"],
                              size,
                              gender,
                              (option) {
                                setState(() {
                                  gender = option;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _nameController.clear();
                                _birthdateController.clear();
                                setState(() {
                                  gender = null;
                                  fileBytes = null;
                                });
                              },
                              child: Text("Clear"),
                            ),
                            ElevatedButton(
                              onPressed: isFilled ? () {} : null,
                              child: Text("Save"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget textFieldWidget(
  TextEditingController controller,
  String labelText,
  Size size,
  IconData icon,
) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.03,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    ),
  );
}

Widget genderListWidget(
  List<String> options,
  Size size,
  String? selectedOption,
  Function onOptionSelected,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: options.map((option) {
      return genderIconWidget(
        option == "Female"
            ? Icons.female
            : option == "Male"
                ? Icons.male
                : option == "Non-Binary"
                    ? Berrybuddy_icons.non_binary
                    : Icons.transgender,
        option,
        size,
        selectedOption,
        () {
          onOptionSelected(option);
        },
      );
    }).toList(),
  );
}

Widget genderIconWidget(
  IconData icon,
  String label,
  Size size,
  String? selectedOption,
  Function onTap,
) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: size.width * 0.07,
          backgroundColor:
              selectedOption == label ? Colors.deepPurple : Colors.transparent,
          child: Icon(
            icon,
            color: Colors.white,
            size: size.width * 0.07,
          ),
        ),
      ],
    ),
  );
}

class ProfileImagePanel extends StatefulWidget {
  @override
  _ProfileImagePanelState createState() => _ProfileImagePanelState();
}

class _ProfileImagePanelState extends State<ProfileImagePanel> {
  List<Uint8List?> profileImages = List.filled(5, null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              profileImages.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      setState(() {
                        profileImages[index] = result.files.first.bytes;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: profileImages[index] != null
                        ? MemoryImage(profileImages[index]!)
                        : null,
                    child: profileImages[index] == null
                        ? const Icon(Icons.add)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
