import 'package:berry_buddy/ui/pages/firstprofile.dart';
import 'package:berry_buddy/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../repositories/userRepository.dart';

class MyProfileForm extends StatefulWidget {
  final String _userId;

  UserRepository _userRepository;

  MyProfileForm({required String userId, UserRepository? userRepository})
      : _userId = userId,
        _userRepository = userRepository ?? UserRepository();

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfileForm> {
  DateTime _birthday = DateTime(1990, 1, 1); // Beispiel-Geburtstag
  String _location = 'New York'; // Beispielort
  String _gender = 'Male'; // Beispielgeschlecht
  String _profileImage = 'assets/profilephoto.png'; // Beispiel-Profilbild

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _roleController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();

  Map<String, dynamic>? userData;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final result = await widget._userRepository.getUserData(widget._userId);
    setState(() {
      userData = result;
      _nameController.text = userData?["name"] ?? '';
      _ageController.text = userData?["birth_date"].toString() ?? '';
      _roleController.text = userData?["role"] ?? '';
      _cityController.text = "Rostock";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildProfilePanel(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade900,
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade400
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
    );
  }

  Widget _buildProfilePanel() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(height: 70),
      // Platz für das Profilbild
      Center(
        child: CircleAvatar(
          radius: 70, // Größe des Profilbilds
          backgroundImage: AssetImage(_profileImage),
        ),
      ),
      SizedBox(height: 20),
      _buildTextPanel(Icons.emoji_people_rounded, _nameController),
      _buildTextPanel(Icons.numbers, _ageController),
      _buildTextPanel(Icons.group, _roleController),
      _buildTextPanel(Berrybuddy_icons.mark_point, _cityController),
      SizedBox(height: 20),
      _buildEditProfileButton()
    ]);
  }

  Widget _buildTextPanel(IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20), // Seitenabstand
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  // Dunkleres Lila für Hintergrund
                  shape: BoxShape.circle, // Runden Kreis für das Symbol
                ),
                child: Icon(
                  icon,
                  color: Colors.deepPurple.shade400, // Lila für Icon
                ),
              ),
              const SizedBox(width: 28), // Abstand zwischen Symbol und Text
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  style: GoogleFonts.redHatDisplay(
                      color: Colors.white, fontSize: 21),
                  // Textfarbe
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white60), // Automatischer Trenner
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FadeTransition(
                opacity: animation,
                //  child: ProfileForm(userRepository: widget._userRepository),
                child: Scaffold(
                  body: BlocProvider<ProfileBloc>(
                    create: (context) => ProfileBloc(
                      userRepository: widget._userRepository,
                    ),
                    child: ProfileSetup(
                      userId: widget._userId,
                      userRepository: widget._userRepository,
                    ),
                  ),
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor:
              MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
        ),
        child: const Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
