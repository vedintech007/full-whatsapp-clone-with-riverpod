import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/widgets/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? _country;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      searchAutofocus: true,
      onSelect: (Country country) {
        setState(() => _country = country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Enter your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "WhatsApp will need to verify your phone number",
            ),
            TextButton(
              onPressed: () => _pickCountry(),
              child: const Text("Pick Country"),
            ),
            heightSpace(5),
            Row(
              children: [
                if (_country != null) Text("+${_country!.phoneCode}"),
                widthSpace(10),
                SizedBox(
                  width: size(context).width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: "phone number",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size(context).height * 0.6),
            SizedBox(
              width: 90,
              child: CustomButton(text: "NEXT", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
