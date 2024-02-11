import 'package:berry_buddy/utils/icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopoint/geopoint.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../repositories/userRepository.dart';

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

  DateTime? selectedDate;
  final TextEditingController birthdateController = TextEditingController();

  String? gender, interestedIn;
  DateTime? age;
  GeoPoint? location;
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    location =
        GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc?.add(
      Submitted(
        name: _nameController.text,
        age: age!,
        location: location!,
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
                    // Dunkle Farbe für das Vordergrund-Panel
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    // Füge einen SingleChildScrollView hinzu, um den RenderFlex-Fehler zu beheben
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: size.width * 0.15,
                          backgroundColor: Colors.transparent,
                          child: fileBytes == null
                              ? GestureDetector(
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
                                  child: Image.asset('profilephoto.png'),
                                )
                              : GestureDetector(
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
                                  child: CircleAvatar(
                                    radius: size.width * 0.15,
                                    backgroundImage: MemoryImage(fileBytes!),
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                        textFieldWidget(_nameController, "Name", size),
                        GestureDetector(
                          child: TextField(
                            controller: birthdateController,
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
                                birthdateController.text = pickedDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                                age = pickedDate;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Birthdate",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "You Are",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.07,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (isButtonEnabled(state)) {
                              _onSubmitted();
                            } else {}
                          },
                          child: Container(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: isButtonEnabled(state)
                                  ? Colors.deepPurple
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.03,
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
